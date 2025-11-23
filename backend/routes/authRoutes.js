import express from "express";
import User from "../models/User.js";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";

const router = express.Router();

/* ===========================
   REGISTER NEW USER
=========================== */
router.post("/register", async (req, res) => {
  try {
    const { name, phone, password } = req.body;

    if (!name || !phone || !password) {
      return res.status(400).json({ message: "All fields are required" });
    }

    // 🚫 Block admin registration from frontend
    if (phone === "9999999999") {
      return res.status(400).json({
        message: "Admin account cannot be registered. It is predefined.",
      });
    }

    const existingUser = await User.findOne({ phone });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await User.create({
      name,
      phone,
      password: hashedPassword,
    });

    const token = jwt.sign(
      { id: newUser._id },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    res.status(201).json({
      message: "Registration successful",
      token,
      user: {
        id: newUser._id,
        name: newUser.name,
        phone: newUser.phone,
      },
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: "Server error" });
  }
});

/* ===========================
   LOGIN (USER + ADMIN)
=========================== */
router.post("/login", async (req, res) => {
  const { phone, password } = req.body;

  /* 🔥 HARD-CODED ADMIN LOGIN */
  if (phone === "9999999999" && password === "Admin@123") {
    const adminToken = jwt.sign(
      { role: "admin" },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    return res.json({
      message: "Admin login successful",
      token: adminToken,
      user: {
        role: "admin",
        phone: "9999999999",
      },
    });
  }

  // Normal user login
  const user = await User.findOne({ phone });
  if (!user) return res.status(400).json({ message: "User not found" });

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch)
    return res.status(400).json({ message: "Invalid credentials" });

  const token = jwt.sign(
    { id: user._id },
    process.env.JWT_SECRET,
    { expiresIn: "1d" }
  );

  res.json({
    message: "Login successful",
    token,
    user: {
      id: user._id,
      name: user.name,
      phone: user.phone,
      role: "user",
    },
  });
});

/* ===========================
   👉 GET TOTAL USERS COUNT
=========================== */
router.get("/total-users", async (req, res) => {
  try {
    const count = await User.countDocuments();

    return res.json({
      totalUsers: count,
    });
  } catch (err) {
    console.error("Error fetching user count:", err);
    res.status(500).json({ message: "Server error" });
  }
});

export default router;

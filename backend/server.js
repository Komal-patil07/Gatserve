import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import connectDB from "./config/db.js";
import authRoutes from "./routes/authRoutes.js";
import mlRoutes from "./routes/mlRoutes.js";

dotenv.config();

const app = express();
app.use(express.json());

// ⭐ STRONG CORS CONFIG (NEEDED FOR FLUTTER WEB)
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

connectDB();

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/ml", mlRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));

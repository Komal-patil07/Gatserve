import express from "express";
import axios from "axios";

const router = express.Router();

router.get("/predict", async (req, res) => {
  const fastApiURL = "http://192.168.0.102:8000/predict";


  console.log("📡 [ML ROUTE] Incoming request to /api/ml/predict");
  console.log("➡️  Trying to contact FastAPI ML server at:", fastApiURL);

  try {
    const response = await axios.get(fastApiURL);

    console.log("✅ [ML ROUTE] Received response from FastAPI:");
    console.log(response.data);

    return res.json(response.data);

  } catch (error) {
    console.log("❌ [ML ROUTE] ERROR while contacting FastAPI!");

    if (error.response) {
      // FastAPI responded with error
      console.log("FastAPI Status:", error.response.status);
      console.log("FastAPI Data:", error.response.data);
    } else if (error.request) {
      // No response received
      console.log("❗ No response from FastAPI server.");
    } else {
      // Some other error
      console.log("Other Error:", error.message);
    }

    return res.status(500).json({
      message: "ML server error",
      error: error.message,
    });
  }
});

export default router;

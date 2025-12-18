import "dotenv/config";
import express from "express";
import http from "http";
import { Server } from "socket.io";
import cors from "cors";
import path from "path";
import { fileURLToPath } from "url";

import pool from "./config/db.js";

import authRoutes from "./routes/authRoutes.js";
import contributionRoutes from "./routes/contributionRoutes.js";
import paymentRoutes from "./routes/paymentRoutes.js";
import loanRoutes from "./routes/loanRoutes.js";
import repaymentRoutes from "./routes/repaymentRoutes.js";
import adminLoanRoutes from "./routes/adminLoanRoutes.js";
import withdrawalRoutes from "./routes/withdrawalRoutes.js";
import memberRoutes from "./routes/memberRoutes.js";
import messageRoutes from "./routes/messageRoutes.js";
import dashboardRoutes from "./routes/dashboardRoutes.js";
import memberDashboardRoutes from "./routes/memberDashboardRoutes.js";
import userSettingsRoutes from "./routes/userSettingsRoutes.js";
import notificationRoutes from "./routes/notificationRoutes.js";
import adminDashboardRoutes from "./routes/adminDashboardRoutes.js";
import reportsRoutes from "./routes/reportsRoutes.js";
import adminRegistrationRoutes from "./routes/adminRegistrationRoutes.js";
import emailTestRoutes from "./routes/emailTestRoutes.js";
import treasurerRoutes from "./routes/treasurerRoutes.js";
import committeeRoutes from "./routes/committeeRoutes.js";

const app = express();
const PORT = 5000;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Middlewares
app.use(
  cors({
    origin: [
      "http://localhost:5173",
      "http://192.168.43.247:5173",
      "https://69904a3d52f0.ngrok-free.app",
      "https://1x0dpkwf-5173.asse.devtunnels.ms", // your devtunnel frontend
    ],
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    credentials: true,
  })
);

app.use((req, res, next) => {
  if (req.originalUrl === "/api/payments/webhook") {
    next();
  } else {
    express.json()(req, res, next);
  }
});

// ✅ Change 4: This line is now fixed.
app.use(
  "/uploads",
  express.static(path.join(__dirname, "uploads", "paymentProofs"))
);

// Serve GCash QR codes
app.use(
  "/uploads/gcash-qr",
  express.static(path.join(__dirname, "uploads", "gcash-qr"))
);

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/contributions", contributionRoutes);
app.use("/api/payments", paymentRoutes);
app.use("/api/loans", loanRoutes);
app.use("/api/repayments", repaymentRoutes);
app.use("/api/admin/loans", adminLoanRoutes);
app.use("/api/withdrawals", withdrawalRoutes);
app.use("/api/members", memberRoutes);
app.use("/api/messages", messageRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/member/dashboard", memberDashboardRoutes);
app.use("/api/user/settings", userSettingsRoutes);
app.use("/api/notifications", notificationRoutes);
app.use("/api/admin/dashboard", adminDashboardRoutes);
app.use("/api/reports", reportsRoutes);
app.use("/api/admin/registrations", adminRegistrationRoutes);
app.use("/api/email", emailTestRoutes);
app.use("/api/treasurer", treasurerRoutes);
app.use("/api/committee", committeeRoutes);

// Create HTTP server for Socket.IO
const server = http.createServer(app);

// Socket.IO setup
const io = new Server(server, {
  cors: { origin: "*" },
});

// Make `io` accessible inside controllers
app.set("io", io);

io.on("connection", (socket) => {
  console.log("⚡ User connected:", socket.id); // User joins their private room

  socket.on("join", (userID) => {
    socket.join(`user_${userID}`);
    console.log(`✅ User ${userID} joined room`);
  });

  socket.on("disconnect", () => {
    console.log("❌ User disconnected:", socket.id);
  });
});

// DB + Server Start
const startServer = async () => {
  try {
    const connection = await pool.getConnection();
    console.log("✅ Connected to MySQL Database");
    connection.release();

    server.listen(PORT, "0.0.0.0", () => {
      console.log(`🚀 Server running with Socket.IO on http://0.0.0.0:${PORT}`);
    });
  } catch (err) {
    console.error("❌ Failed to connect to Database:", err.message);
    process.exit(1);
  }
};

startServer();

import express from "express";
import { getUserProfile, updateUserProfile, changePassword, requestPasswordReset, uploadGCashQR } from "../controllers/userSettingsController.js";
import auth from "../middleware/auth.js";
import uploadGCashQRMiddleware from "../middleware/multerGCash.js";

const router = express.Router();

// Apply auth middleware to all routes
router.use(auth);

// Get user profile information
router.get("/profile", getUserProfile);

// Update user profile information
router.put("/profile", updateUserProfile);

// Upload GCash QR code
router.post("/gcash-qr", uploadGCashQRMiddleware.single('gcash_qr_code'), uploadGCashQR);

// Change password
router.put("/password", changePassword);

// Request password reset (public route - no auth required)
router.post("/password-reset", requestPasswordReset);

export default router;

const express = require("express");
const User = require("../models/user");

const authRouter = express.Router();

// GET POST UPDATE DELETE PATCH
// app.get("/api/get", () => {});
// app.post("/api/signup", () => {});
// app.post("/api/update", () => {});
// app.post("/api/delete", () => {});

authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, profilePic } = req.body;
    let user = await User.findOne({ email });

    if (!user) {
      user = new User({
        email,
        profilePic,
        name,
      });
      user = await user.save();
    }
    //encode toJson
    res.status(200).json({ user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;

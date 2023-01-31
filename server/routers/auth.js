const express = require("express");
const User = require("../models/user");
const jwt = require("jsonwebtoken");
const auth = require("../middleware/auth");

const authRouter = express.Router();

// GET POST UPDATE DELETE PATCH
// app.get("/api/get", () => {});
// app.post("/api/signup", () => {});
// app.post("/api/update", () => {});
// app.post("/api/delete", () => {});

//flutterやthunderClientからPOSTで送られる。
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
    const token = jwt.sign({ id: user._id }, "passwordKey");
    console.log(token);

    //encode toJson
    res.status(200).json({ user, token });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//authでreq.userが設定されて、第3引数に渡される。
authRouter.get("/", auth, async (req, res) => {
  console.log(req.user);
  const user = await User.findById(req.user);
  const token = req.user;
  res.json({ user, token });
});

module.exports = authRouter;

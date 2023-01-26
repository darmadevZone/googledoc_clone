/**
 * mongoose database model file
 * column : name email profilePic and type Opition
 */
const mongoose = require("mongoose");

//User model 設計図
const userSchema = mongoose.Schema({
  name: {
    type: String,
    require: true,
  },
  email: {
    type: String,
    require: true,
  },
  profilePic: {
    type: String,
    require: true,
  },
});

const User = mongoose.model("User", userSchema);
module.exports = User;

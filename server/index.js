const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const authRouter = require("./routers/auth");
const documentRouter = require("./routers/document");

const PORT = process.env.PORT | 3001;

const app = express();
const DB =
  "mongodb+srv://darma:zeLIneeRlhxn7tB1@cluster0.hakv9n0.mongodb.net/?retryWrites=true&w=majority";

//クロスオリジンエラーの対処
app.use(cors());
//use to json middleware
app.use(express.json());
//middleware
//Router
app.use(authRouter);
app.use(documentRouter);
/**
 * app.listen(PORT, () => {
  console.log(`conneced at port ${PORT}`);
});
 */
mongoose
  .connect(DB)
  .then(() => {
    console.log("connection succeced");
  })
  .catch((err) => {
    console.log(err);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`conneced at ${PORT}`);
});

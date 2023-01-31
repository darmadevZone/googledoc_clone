const jwt = require("jsonwebtoken");
/*
frontendからmiddlewareにアクセスをしてJWT認証(取得)を可能にする。
*/
const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");

    if (!token) {
      return res.status(401).json({ msg: "No auth token, access denied." });
    }

    //tokenの検証 + server側と検証
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied" });
    }
    req.user = verified.id;
    req.token = token;

    //middleware側、server側に処理が送られる。express独自
    next();
  } catch (e) {
    req.status(500).json({ error: e.message });
  }
};

module.exports = auth;

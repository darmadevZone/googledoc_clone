const mongoose = require("mongoose");

const documentSchema = mongoose.Schema({
  uid: {
    type: String,
    require: true,
  },
  createdAt: {
    require: true,
    type: Number,
  },
  title: {
    require: true,
    type: String,
    trim: true,
  },
  content: {
    type: Array,
    default: [],
  },
});

const Document = mongoose.model("Document", documentSchema);

module.exports = Document;

/*
DocumentModel

-   user id
-   created at
-   title
-   content
*/

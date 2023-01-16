/* eslint-disable */ 
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendListenerPushNotification = functions.database.ref("/posts/{postId}")
.onCreate((data, context) => {
	console.log("post was created: ", context.params.postId);
});

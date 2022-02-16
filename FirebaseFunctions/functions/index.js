

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()
const firestore = admin.firestore()

const pushMessage = (fcmToken, reactionmessage, username) => ({
  notification: {
    title: 'Ubatge',
    body: `${username}\n${reactionmessage}`,
  },
  data: {
    hoge: 'fuga', // 任意のデータを送れる
  },
  token: fcmToken,
})
// notificationReactionMessage, notificationUserName
//「${notificationUserName}\n${notificationReactionMessage}」

exports.notificationPush = functions.firestore
  .document('users/{userID}/Notification/{NotificationID}')
  .onCreate((snapshot, context) => {
    // 以下のようにすればbookの中身が取れる.
   const Notification = snapshot.data()
    // 以下のようにすればuserIDやbookIDが取れる.
    const userID = context.params.userID
    const userRef = firestore.doc(`users/${userID}`)
    userRef.get().then((users) => {
      const userData = users.data()
      admin.messaging().send(pushMessage(userData.fcmToken, Notification.reactionMessage, Notification.userName))
        .then((response) => {
          console.log('Successfully sent message:', response)
        })
        .catch((e) => {
          console.log('Error sending message:', e)
        })
    }).catch((e) => console.log(e))
  })
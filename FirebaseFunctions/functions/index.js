

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

const pushMessage = (fcmToken, reactionMessage, userName) => ({
  notification: {
    title: `「${userName}」`,
    body: `「${reactionMessage}」の保存が完了しました🙌`,
  },
  data: {
    hoge: 'fuga', // 任意のデータを送れる
  },
  token: fcmToken,
})

exports.NotificationPush = functions.firestore
  .document('users/{userID}/Notification/{notificationId}')
  .onCreate((snapshot, context) => {
    // 以下のようにすればbookの中身が取れる.
    const notificationId = snapshot.data()
    // 以下のようにすればuserIDやbookIDが取れる.
    const userId = context.params.userId
    const userRef = firestore.doc(`users/${userId}`)
    userRef.get().then((userId) => {
      const userData = userId.data()
      admin.messaging().send(pushMessage(userData.fcmToken, notificationId.reactionMessage, notificationId.userName))
        .then((response) => {
          console.log('Successfully sent message:', response)
        })
        .catch((e) => {
          console.log('Error sending message:', e)
        })
    }).catch((e) => console.log(e))
  })
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Règles spécifiques pour la collection "commentaire"
    match /Commentaire/{document=*} {
      allow read, write: if request.auth != null;
    }
    // Règles spécifiques pour la collection "users"
    match /User/{userId} {
      // Permet d'écrire dans "users" lors de l'enregistrement
      allow write: if request.auth != null && request.auth.uid == userId;

      // Permet de lire uniquement son propre document ou si son UID est dans le tableau "friends"
      allow read: if request.auth != null && (
    request.auth.uid == userId ||
    exists(/databases/$(database)/documents/User/$(userId)/friends/$(request.auth.uid))
  );
    }
    match /Conversation/{document=*} {
      // Permet de lire et écrire si l'utilisateur est dans la liste des participants
      allow read, write: if request.auth != null && request.auth.uid in resource.data.participants;
    	allow create: if request.auth != null && request.auth.uid in request.resource.data.participants;
    }
    match /Post/{document}{
    	allow read: if request.auth != null;
      allow write : if request.auth != null && request.auth.uid == resource.data.idUser;
      allow create: if request.auth != null && request.auth.uid==	request.resource.data.idUser;
    }
    match /Message/{document} {
      // Permet de lire ou d'écrire si l'utilisateur est un participant de la conversation associée à ce message
      allow read, write: if request.auth != null &&
        request.auth.uid in get(/databases/$(database)/documents/Conversation/$(resource.data.idConversation)).data.participants;

      // Permet de créer un message si l'utilisateur est un participant de la conversation associée
      allow create: if request.auth != null &&
        request.auth.uid in get(/databases/$(database)/documents/Conversation/$(request.resource.data.idConversation)).data.participants;
    }
		match /User/{userId}/friends/{friendId} {
      allow read: if request.auth != null && (request.auth.uid == userId || request.auth.uid == friendId);
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    match /{document=**} {
      allow read, write: if false;
    }
  }
}

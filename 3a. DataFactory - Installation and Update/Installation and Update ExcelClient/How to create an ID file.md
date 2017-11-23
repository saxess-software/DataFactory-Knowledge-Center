An ID file is like a saved identity card. Create it only on privae computers, it contains your 
password in encrypted, but useable form.
The ID file prevents you from entering your credentials for a WebCluster, if you do not store the credentials 
in the key (because many user use this Key, or because you have many Key files)

1. enter you web credentials into the connection to the Templatestore
2. test and save the connection
3. copy the key of the templatestore from folger "Keys" to "IDs"
4. change the file extension form *.pfk to *.pfc
5. open the file using an editor and delete all lines except "User" and "Password"
6. the passwort must be encoded to Base64 format (use for example <https://www.base64encode.org/>)

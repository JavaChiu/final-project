# Developers notice
This project uses "cocoapods", https://cocoapods.org/, so while developing, you have to open the project with .xcworkspace file. Also, make sure the libraries are shared in the scheme. 

# Working-on
- Jerry: NewPostViewController
- Andrew:
1. Backend Service: Hosted a rest service on aws, but since iOS requires SSL connection, probably can't integrate with it right now. Tried with self-served SSL, no use.

https://ec2-34-211-177-131.us-west-2.compute.amazonaws.com:8443/swagger-ui.html#!/

https://ec2-34-211-177-131.us-west-2.compute.amazonaws.com:8443/api/users

https://ec2-34-211-177-131.us-west-2.compute.amazonaws.com:8443/api/items

2. MainFeedViewController

# To-do list
- NewPostViewController
    - Address needs to include more detail
    - Submit button needs to create object and pass to storage
- MyPostViewController
    - Create TableView and update from storage

# Third-Party Frameworks
1. FacebookCore
2. FacebookLogin
3. Firebase/Core
4. Firebase/Storage
5. Firebase/Database
6. FirebaseUI/Auth
7. CodableFirebase

# Attribution
- Icon made by https://www.flaticon.com/authors/freepik from www.flaticon.com

https://www.simplifiedios.net/facebook-login-swift-3-tutorial/, https://gist.github.com/reterVision/091200424e122ef14c8c

https://github.com/dillidon/alerts-and-pickers

https://stackoverflow.com/questions/27652227/text-view-placeholder-swift

https://gist.github.com/tomasbasham/10533743

https://stackoverflow.com/questions/32281651/how-to-dismiss-keyboard-when-touching-anywhere-outside-uitextfield-in-swift

https://www.simplifiedios.net/facebook-login-swift-3-tutorial/, https://gist.github.com/reterVision/091200424e122ef14c8c

https://stackoverflow.com/questions/11862883/attempt-to-present-uiviewcontroller-on-uiviewcontroller-whose-view-is-not-in-the

https://stackoverflow.com/questions/39616821/swift-3-0-data-to-string

https://stackoverflow.com/questions/25623272/how-to-use-scnetworkreachability-in-swift

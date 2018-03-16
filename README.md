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

# Done
1. User setting bundle

# Third-Party Frameworks
1. Facebook Login SDK

# Attribution
- Icon made by https://www.flaticon.com/authors/freepik from www.flaticon.com

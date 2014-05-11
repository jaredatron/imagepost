


## Documentation

- https://dev.twitter.com/docs/auth/authorizing-request



## Scenarios

When not signed in
And  I visit the homepage
Then I should be able to create a "post"
When I post that "post" to Twitter
Then I should be prompted to connect to Twitter
When I connect to twitter
Then I should be signed in
And  the "post" should be posted to Twitter
And  I should be on the show page for that "post"


When I am signed in
And  I visit the homepage
Then I should be

- homepage:
  - you can create a post right away
  - below the editor is a "post to twitter" and "post to facebook" button
  - when not connected these button promp to connect to said service
  - after successful connection the post is made automatically and the user returns to the show page of the post they created

- description, asked to sign in with twitter
- sign in with twitter
- prompted to create a text image
- can see previous posts
- can repost previous posts

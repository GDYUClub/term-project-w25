# How to contribute code to the Winter Term Project (2025)

- If you just randomly stumbled upon this repo reach out to someone in the gdyu discord server for further info.

## 1. Install Relevant software

Please make sure you have the following on your computer:

- [Godot 4.3](https://godotengine.org/download/)
- [Python 3.12](https://www.python.org/)
- [Pip](https://pypi.org/project/pip/)
- [godot-gdscript-toolkit](https://github.com/Scony/godot-gdscript-toolkit)
- [Git](https://www.freecodecamp.org/news/guide-to-git-github-for-beginners-and-experienced-devs/)

## 2. Join + Clone the Repository

- Give us your Github email.
- We'll add you as a maintainer on the project.
- From there, clone the project by copying and pasting the command in the `<> Code` button into whatever you use for github.
- Open the project in godot.
- You now have the game running on your computer!

## 3. Get a task + make a branch

- Get a task from a team lead.
- Make a branch to work on it the branch should be named after your feature:

```
git checkout -b <name>
```

Work within this branch when making your contribution.

## 4. Complete the task

- After you make your branch, complete the task!
- Make sure your code follows the [gdscript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- Make sure your files follow the [godot project orginization guidelines](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html), and you place things in the correct folders.
- Make sure you run the [godot-gdscript-toolkit](https://github.com/Scony/godot-gdscript-toolkit) linter to ensure consistency in code style.

## 5. Add and commit your code

- Add and commit your code to the repo, then push it so it's in github.

```
git add <filename>
git commit -m <message>
git push --set-upstream origin <branch>
```

- If you're using VS Code, you can also use the Source Control tab to easily add and commit without typing the commands.

## 6. Create a pull request

- Go to the github repo and click on the [pull requests tab](https://github.com/GDYUClub/term-project-w25/pulls)
- Create a new pull request with your branch merging into main:

```
base: main <- compare:your branch
```

- You can then create the pull request

## 6b. "The pull request can't be merged!"

- Congrats, your first merge conflict!
- This issue comes from the file(s) in main being different than the files in your branch, and conflicting with each other.
- You can manually open up the conflicting files to try to edit them, but if you aren't comfortable with dealing with merge conflicts, ask a team lead for help.

## 7. Have your Pull request approved

- Wait for a team lead to approve your pull request.
- Merge it!
- Yipee! You did it!

### For Any Questions

- Refer to the programming-chat channel in the winter 2025 project discord server (you should've been sent a invitation for it)

Usually we work only with GitHub Desktop, but sometimes - in case of conflicts we must use the GitShell

If you have a conflict in GitHub Desktop, do the following:
* Open GitShell
* Navigate to your Repository by entering cd [Start of Name of Repo] - TabKey 
* enter git status
    * now you should see (a bit cryptic) the status of the repo
* do something depended on the status, e.g.
    * get all remote changes with git pull
    * push your changes with git push
    * add files with git add .

* if nothing helps, save you local changed files anywhere outside git and
    * git fetch --all
    * git reset --hard origin/master

git fetch downloads the latest from remote without trying to merge or rebase anything.
Then the git reset resets the master branch to what you just fetched. The --hard option changes all the files in your working tree to match the files in origin/master

Ways to crash GitHub
* use the pipe in a filename (happend in DataFactory Knowledge Center)
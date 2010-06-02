Princeton Merchants Association's Website
=========================================

PMA’s mission is to assist local businesses achieve their business goals.  We do this by helping our members develop and access educational programs, collaborative marketing opportunities, and contemporary communication tools. 

Our overall goal is to create a vibrant and sustainable local economy in Princeton by attracting, nurturing, and maintaining a mix of businesses that serve the economic, social and material needs of our community and make Princeton a great place to live and work.

To get involved in the development of our website and platform, use the guide below. Feel free to contact joseph@princetonmerchants.org for more information.

Setup
-----

1. Fork our repository to your own Github account.
2. Clone your fork:

        git clone [your fork's read and write url]

3. Import the database (assuming you have db/data.yml), then start-up the site to make sure it works at http://localhost:3000/:

        cd pma
        rake db:import
        script/server
  
4. Setup your local Git repository to work with your remote repository as well as ours. Copy GITCONFIG to .git/config, then change "[YOUR USERNAME]" in .git/config to your Github username.


Staying In-Sync
---------------

Don't use git merge to stay syncronized with our repository. Instead, you should use git rebase. For example:

    git fetch upstream master 
    git rebase upstream/master

  
If any conflicts need to be resolved during the rebase, fix them, add them to the current commit, then continue the rebase. For example:

    git add file_with_resolved_conflicts
    git rebase --continue


Submitting Changes
------------------

Simply push your commits to your repository, then submit a pull request.

Bugs and Feature Requests
-------------------------

Please use Github [issues][1].


  [1]: http://github.com/princetonmerchants/pma/issues
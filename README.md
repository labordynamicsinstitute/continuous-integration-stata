[![Test CI Stata](https://github.com/labordynamicsinstitute/continuous-integration-stata/actions/workflows/test.yml/badge.svg)](https://github.com/labordynamicsinstitute/continuous-integration-stata/actions/workflows/test.yml)

# About

Hello world! Are you a researcher working primarily using Stata? Have you ever:
- Gotten a headache working with cross-platform (e.g. Windows vs Mac OS)?
- Tried to reproduce a code published by other researchers but it doesn't work out on your machine?
- Overwritten your codes and data (after years of sweat and blood!) using another platform (e.g. Dropbox, Onedrive)?
- All of the above?

Imagine that you can avoid all of that. And that's what this repository is aiming for!

# Potential use cases

In addition to solving the problems above, you can benefit from this repository in some of the following ways:
- Producing regression tables on LaTeX without having to install the distribution on your local machine—which can be pain in the neck
- Running unit tests if you're building a Stata package. This is something that I find lacking compared to other open source statistical packages (Julia/R/Python)

# Workflows


Since Stata has user-written packages that users may have not installed on their machine, it sometimes can be a cause of an error. Hence, it may be a good practice to run the following code in the beginning of your `main.do` file:

```stata
clear

// list packages that we may want to install
local packages = "unique reghdfe ritest estout ivreghdfe ftools ivreg2" // just for example

foreach i of local packages {
	capture which `i'
	if _rc != 0 {
		display _rc
		ssc install `i', replace
	}
}
```

# Does it really work to your paper?

Yes! Check out this [paper](https://github.com/adviksh/when-guidance-changes) from Charlie Rafkin, Advik Shreekumar, and Pierre-Luc Vautrey, where I clone their repository and run the corresponding Stata do-files (not the R code since it's about Stata workflow) in my [main.do](https://github.com/ledwindra/continuous-integration-stata/blob/main/main.do) (**see lines 20-50**)

# What you need

In order to run
Stata do-file using GitHub Actions you need:

- Serial number
- Code
- Authorization

# How to run?
You can download the source code from [here](https://github.com/labordynamicsinstitute/continuous-integration-stata/releases). Make sure to choose the latest version available. Then, you can create your own repository on GitHub. Before going any further, you need to add GitHub Secrets on `Settings -> Secrets` tab inside your repository. Note that only **you** can see these environment variables unless you make them public (but don't!). Though I make this package, I **can not** see them either. What you need are the following:

- ACCESS_TOKEN: you need a token that authorizes GitHub to make any git commit on behalf your account. Read [here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) for details
- AUTHORIZATION: given by Stata
- CODE: given by Stata
- EMAIL: your GitHub email for git configuration (`git config --global user.email`). See [here](https://www.git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)
- FIRST_NAME: your Stata first name
- LAST_NAME: your Stata last name
- SERIALNUMBER: given by Stata
- PROGRAM: the relative path to the program to run (e.g., `test/run.do`)
- VERSION: your Stata version (I use 15)

That's it! Then you can go to `Actions` tab and just click `Run workflow` and voila! You've just run a Stata do-file using GitHub's owned machine. 😀

# Considerations

See [the original repository](https://github.com/ledwindra/continuous-integration-stata/) for additional notes.

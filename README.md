[![Test CI Stata](https://github.com/labordynamicsinstitute/continuous-integration-stata/actions/workflows/test.yml/badge.svg)](https://github.com/labordynamicsinstitute/continuous-integration-stata/actions/workflows/test.yml)

# About

This Github Action allows a user to leverage cloud computing to do continuous integration with Stata code. An example follows. A user will need a valid Stata license, access to the [dataeditors/stata17](https://hub.docker.com/r/dataeditors/stata17), and a self-contained (reproducible) Stata replication package. The Stata code has access to the internet during processing, but we suggest to pre-emptively install all Stata dependencies into a local ado directory.

# Original creator

A version of this Github Action was first created by [ledwindra/continuous-integration-stata](https://github.com/ledwindra/continuous-integration-stata). Kudos to him. This version was primarily adapted to work with a pre-configured Stata Docker image, and to use encoded license information (also based on prior work by [ledwindra](https://github.com/ledwindra)).


# Limitations

- This simple Github Action does not include the ability to run other code (Julia/R/Python/LaTeX). However, it would be easy to expand. See [ledwindra/continuous-integration-stata](https://github.com/ledwindra/continuous-integration-stata) for examples.
- This action is currently hard-coded to use Stata 17, but can easily be adapted to use other Stata versions.

# Sample Workflow

This Github Action uses itself to validate functionality. See [.github/workflows/test.yml](.github/workflows/test.yml) for an example.


# What you need

In order to run
Stata do-file using GitHub Actions you need:

- Serial number
- Code
- Authorization

# Configuration

To run the Stata part, you need to call this action. Verify the latest [release/](release/).

```
    - name: Stata Action
      id: ci-stata
      uses: labordynamicsinstitute/continuous-integration-stata@v0.1
```

Parameters to be set:

- `program`: program to be run. Can be in a subdirectory. Only one program per call, but you can add multiple sections to the YML file.
- `version`: parameter kept for the Stata version, but presently non-functional (hard-coded to `17`)
- `serial-number`: The Stata serial number from your license
- `code`: The license code from your Stata license
- `authorization`: The authorization code from your Stata license
- `name`: The first line of the Stata license field, typically your name
- `institution`: The second line of the Stata license field, typically your institution
- `changedir`: (optional) Should the working directory be changed to the file location being run (cd dir ; stata prog.do) or not (stata dir/prog.do). Affects environment for Stata


Since most of these are private parameters, they should be encoded as [Github secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets), by either setting the secrets through the Github web interface, or from the command line:

```{bash}
gh secret set STATA_SERIALNUMBER -b123456789                                        -o myorganization 
gh secret set STATA_CODE         -b'Lore mips umdo lors itam etco nsec tetu radi p' -o myorganization 
gh secret set STATA_AUTH         -bisci                                             -o myorganization 
gh secret set STATA_NAME         -b"Your Name"                                      -o myorganization
gh secret set STATA_INSTITUTION  -b"Your Institution"                               -o myorganization
```

You may need to set the Github secret permissions to be available to specific repos or to the entire organization (the above syntax works for "private" repositories):

```
  Set organization level secret visible to entire organization
  $ gh secret set MYSECRET -bval --org=anOrg --visibility=all
  
  Set organization level secret visible only to certain repositories
  $ gh secret set MYSECRET -bval --org=anOrg --repos="repo1,repo2,repo3"
```


Example of usage in Github Workflow (full example [here](https://github.com/labordynamicsinstitute/continuous-integration-stata/blob/main/.github/workflows/test.yml))

```
      with:
        program: test/run.do
        version: ${{ secrets.STATA_VERSION }}
        serial-number: ${{ secrets.STATA_SERIALNUMBER }}
        code: ${{ secrets.STATA_CODE }}
        authorization: ${{ secrets.STATA_AUTH }}
        name: ${{ secrets.STATA_NAME }}
        institution: ${{ secrets.STATA_INSTITUTION }}
        changedir: yes
```

The sample implementation also commits results back to the repository, and you may be interested in doing so as well. We use the great [https://github.com/peaceiris/actions-gh-pages/](https://github.com/peaceiris/actions-gh-pages/) to simplify the configuration, you can check out all required configuration parameters on their page. 

# Considerations

See [the original repository](https://github.com/ledwindra/continuous-integration-stata/) for additional notes.

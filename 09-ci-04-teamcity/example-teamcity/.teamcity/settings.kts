import jetbrains.buildServer.configs.kotlin.*
import jetbrains.buildServer.configs.kotlin.buildSteps.maven
import jetbrains.buildServer.configs.kotlin.sharedResource
import jetbrains.buildServer.configs.kotlin.triggers.vcs

/*
The settings script is an entry point for defining a TeamCity
project hierarchy. The script should contain a single call to the
project() function with a Project instance or an init function as
an argument.

VcsRoots, BuildTypes, Templates, and subprojects can be
registered inside the project using the vcsRoot(), buildType(),
template(), and subProject() methods respectively.

To debug settings scripts in command-line, run the

    mvnDebug org.jetbrains.teamcity:teamcity-configs-maven-plugin:generate

command and attach your debugger to the port 8000.

To debug in IntelliJ Idea, open the 'Maven Projects' tool window (View
-> Tool Windows -> Maven Projects), find the generate task node
(Plugins -> teamcity-configs -> teamcity-configs:generate), the
'Debug' option is available in the context menu for the task.
*/

version = "2022.04"

project {

    buildType(Build)

    template(MavenBuild)

    params {
        text("cat_name", "Wizzard", readOnly = true, allowEmpty = true)
        param("env.cat_name", "%cat_name%")
        param("env.name", "Alexey1")
    }

    features {
        sharedResource {
            id = "PROJECT_EXT_2"
            name = "ya"
            resourceType = quoted(100)
        }
    }
}

object Build : BuildType({
    templates(MavenBuild)
    name = "Build"
})

object MavenBuild : Template({
    name = "maven build"

    artifactRules = "target/*.jar => target"

    vcs {
        root(DslContext.settingsRoot)
    }

    steps {
        maven {
            id = "RUNNER_1"

            conditions {
                doesNotContain("teamcity.build.branch", "master")
            }
            goals = "clean test"
            runnerArgs = "-Dmaven.test.failure.ignore=true"
            userSettingsSelection = "settings.xml"
        }
        maven {
            name = "Deploy"
            id = "RUNNER_4"

            conditions {
                contains("teamcity.build.branch", "master")
            }
            goals = "clean deploy"
            runnerArgs = "-Dmaven.test.failure.ignore=true"
            userSettingsSelection = "settings.xml"
        }
    }

    triggers {
        vcs {
            id = "TRIGGER_1"
        }
    }
})

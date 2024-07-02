jobs:
  - script: >
      job('testJob1') {
          scm {
              git('git://github.com/quidryan/aws-sdk-test.git')
          }
          triggers {
              scm('H/15 * * * *')
          }
          steps {
              maven('-e clean test')
          }
      }

  - script: >
      job('testJob2') {
          scm {
              git('git://github.com/quidryan/aws-sdk-test.git')
          }
          triggers {
              scm('H/15 * * * *')
          }
          steps {
              maven('-e clean test')
          }
      }

  - file: ./jobdsl/job1.groovy
  - file: ./jobdsl/job2.groovy
#
# Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
# WSO2 Inc. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
#!/bin/bash

DISTRIBUTION_PATH=${1}
DOCKER_BALO_MAVEN_PROJECT_ROOT=${2}

# TEMP
#rm -rf ${DISTRIBUTION_PATH}/*
#cp -r /Users/hemikak/ballerina/dev/ballerina/distribution/zip/jballerina-tools/build/distributions/jballerina-tools-1.0.0-beta-SNAPSHOT/* ${DISTRIBUTION_PATH}

EXECUTABLE="${DISTRIBUTION_PATH}/bin/ballerina"
DOCKER_BALLERINA_PROJECT="${DOCKER_BALO_MAVEN_PROJECT_ROOT}/src/main/ballerina/ballerina"
DISTRIBUTION_BIR_CACHE="${DISTRIBUTION_PATH}/bir-cache/ballerina/docker/0.0.0/"
DISTRIBUTION_SYSTEM_LIB="${DISTRIBUTION_PATH}/bre/lib/"

mkdir -p ${DISTRIBUTION_BIR_CACHE}
mkdir -p ${DISTRIBUTION_SYSTEM_LIB}

rm -rf ${DOCKER_BALLERINA_PROJECT}/target

if ! hash pushd 2>/dev/null
then
    cd ${DOCKER_BALLERINA_PROJECT}
    JAVA_OPTS="-DBALLERINA_DEV_COMPILE_BALLERINA_ORG=true" ${EXECUTABLE} build -c -a --skip-tests
    cd -
else
    pushd ${DOCKER_BALLERINA_PROJECT} /dev/null 2>&1
        JAVA_OPTS="-DBALLERINA_DEV_COMPILE_BALLERINA_ORG=true" ${EXECUTABLE} build -c -a --skip-tests
    popd > /dev/null 2>&1
fi

cp -r ${DOCKER_BALLERINA_PROJECT}/target/* ${DOCKER_BALO_MAVEN_PROJECT_ROOT}/target

cp -r ${DOCKER_BALO_MAVEN_PROJECT_ROOT}/target/caches/bir_cache/ballerina/docker/docker.bir ${DISTRIBUTION_BIR_CACHE}
cp ${DOCKER_BALO_MAVEN_PROJECT_ROOT}/target/caches/jar_cache/ballerina/docker/ballerina-docker-.jar ${DISTRIBUTION_SYSTEM_LIB}/docker.jar
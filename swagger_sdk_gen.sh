if $Build_Codegen ; then
    mvn3 clean package -Dmaven.test.skip=true -Dmaven.clean.failOnError=false
fi
curl -k "http://newapi.nightly.capillary.in/version.json" -o config.json
echo "GENERATING SDK"
if [ "$Client" = "java" ]
then 
  rm -rf intouch_api/java_client/java
  java -jar modules/swagger-codegen-cli/target/swagger-codegen-cli.jar generate \
  -i http://newapi.nightly.capillary.in/swagger.json  \
  -l java \
  -DdateLibrary=java8 \
  -o intouch_api/java_client/java \
  -c config.json
  tar cvzf intouch_api/java_client/java_swagger_sdk_$BUILD_NUMBER.tar.gz -C ./intouch_api/java_client/java/ .
  mvn3 clean deploy -f intouch_api/java_client/java/pom.xml
elif [ "$Client" = "c#" ]
then rm -rf intouch_api/csharp_client/c#
   java -jar modules/swagger-codegen-cli/target/swagger-codegen-cli.jar generate \
  -i http://newapi.nightly.capillary.in/swagger.json \
  -l csharp\
  -DtargetFramework=v$Version \
  -o intouch_api/csharp_client/c#
  tar cvzf intouch_api/csharp_client/c#swagger_sdK_$BUILD_NUMBER.tar.gz -C ./intouch_api/csharp_client/c#/ .
elif [ "$Client" = "php" ]
then rm -rf intouch_api/php_client/php
   java -jar modules/swagger-codegen-cli/target/swagger-codegen-cli.jar generate \
  -i http://newapi.nightly.capillary.in/swagger.json  \
  -l php \
  -o intouch_api/php_client/php
  tar cvzf intouch_api/php_client/php_swagger_sdk_$BUILD_NUMBER.tar.gz -C ./intouch_api/php_client/php/ .
elif [ "$Client" = "nodejs" ]
then rm -rf intouch_api/nodejs_client
	mkdir -p intouch_api/nodejs_client/
	 curl http://newapi.nightly.capillary.in/swagger.json > swagger.json
     npm install swagger-js-codegen
     cd swagger-js-codegen
     node ../nodejs_sdk_gen > ../intouch_api/nodejs_client/node_$BUILD_NUMBER
else " no client is selected"
fi
echo "SWAGGER SDK SUCCESSFULLY GENERATED"

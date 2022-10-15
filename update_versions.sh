export APP_VERSION=1.4.2
export BUILD_NUMBER=106
sed -i '' "s/version: .*/version: $APP_VERSION+$BUILD_NUMBER/" pubspec.yaml && \
sed -i '' "s/versionCode .*/versionCode $BUILD_NUMBER/" android/app/build.gradle && \
sed -i '' "s/versionName .*/versionName '$APP_VERSION'/" android/app/build.gradle && \
unset APP_VERSION
unset BUILD_NUMBER


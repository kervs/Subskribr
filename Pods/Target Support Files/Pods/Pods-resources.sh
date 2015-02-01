#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm\""
      xcrun mapc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
          install_resource "AWSiOSSDKv2/AWSCore/CognitoIdentity/Resources/cognito-identity-2014-06-30.json"
                    install_resource "AWSiOSSDKv2/AWSCore/MobileAnalyticsERS/Resources/mobileanalytics-2014-06-30.json"
                    install_resource "AWSiOSSDKv2/AWSCore/STS/Resources/sts-2011-06-15.json"
                    install_resource "AWSiOSSDKv2/AutoScaling/Resources/autoscaling-2011-01-01.json"
                    install_resource "AWSiOSSDKv2/CloudWatch/Resources/monitoring-2010-08-01.json"
                    install_resource "AWSiOSSDKv2/DynamoDB/Resources/dynamodb-2012-08-10.json"
                    install_resource "AWSiOSSDKv2/EC2/Resources/ec2-2014-09-01.json"
                    install_resource "AWSiOSSDKv2/ElasticLoadBalancing/Resources/elasticloadbalancing-2012-06-01.json"
                    install_resource "AWSiOSSDKv2/Kinesis/Resources/kinesis-2013-12-02.json"
                    install_resource "AWSiOSSDKv2/S3/Resources/s3-2006-03-01.json"
                    install_resource "AWSiOSSDKv2/SES/Resources/email-2010-12-01.json"
                    install_resource "AWSiOSSDKv2/SNS/Resources/sns-2010-03-31.json"
                    install_resource "AWSiOSSDKv2/SQS/Resources/sqs-2012-11-05.json"
                    install_resource "AWSiOSSDKv2/SimpleDB/Resources/sdb-2009-04-15.json"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/amex.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/amex@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc-amex.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc-amex@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/diners.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/diners@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/discover.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/discover@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/jcb.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/jcb@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/mastercard.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/mastercard@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/placeholder.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/placeholder@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/visa.png"
                    install_resource "PaymentKit/PaymentKit/Resources/Cards/visa@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/gradient@2x.png"
                    install_resource "PaymentKit/PaymentKit/Resources/textfield.png"
                    install_resource "PaymentKit/PaymentKit/Resources/textfield@2x.png"
          
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi

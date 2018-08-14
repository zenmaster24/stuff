#~/bin/bash -ex
# usage
# directory to ${outputdir}
# ./import-files.sh ~/Pictures/willowview willoview "Willowview farm stay 2018" mp4
# single file to ${outputdir}
# ./import-files.sh /Users/kirk/Pictures Emily "Karate kumite" VID_20180623_151737.mp4
# view existing tags
# exiftool -a -s -G1 IMG_20180610_131124.jpg

author=$(finger $LOGNAME | head -1 | awk -F': ' '{print $3}')
path=${1:-./}
albumname=${2:-}
ext=${3:-.jpg}
files=$(ls -A ${path}/*${ext})
outputdir=${4:-~/Pictures}

if ! type "exiftool" &> /dev/null; then
  echo "exiftool needs to be installed - https://www.sno.phy.queensu.ca/~phil/exiftool/"
fi

for file in ${files}; do
  echo -e "Editing file ${file} -\n\tAdding XMP data (albumname=${albumname}) to ${file}"
  exiftool -sep "," -XMP-dc:Subject="${albumname},${keywords}" -XMP-dc:Creator="${author}" ${file}
  echo -e "\tMoving file ${file} to final directory under ${outputdir} based on date"
  exiftool -d ${outputdir}/%Y/%m "-directory<filemodifydate" "-directory<createdate" "-directory<datetimeoriginal" ${file};
done
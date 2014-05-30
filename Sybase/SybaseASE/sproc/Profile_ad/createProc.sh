if [ $# -ne 6 ] ; then
  echo "Usage: <DBServer>"
  echo "Usage: <DBName>"
  echo "Usage: <ProductCode>"
  echo "Usage: <CommunityCode>"
  echo "Usage: <ProcName>"
  echo "Usage: <Password>"
  exit 1
fi

#
# Initialize arguments
#

SQSH=sqsh
BCP=bcp

DBServer=$1
DBName=$2
ProductCode=$3
CommunityCode=$4
ProcName=$5
Password=$6

yyyymmddHHMMSS=`date '+%Y%m%d%H%M%S'`

cat ${ProcName}.sql > output/${ProcName}.sql.${yyyymmddHHMMSS}.${DBName}

./searchReplace Profile_a${CommunityCode} Profile_${ProductCode}${CommunityCode} output/${ProcName}.sql.${yyyymmddHHMMSS}.${DBName} ${Password}

./searchReplace ProfileShow_a${CommunityCode} ProfileShow_${ProductCode}${CommunityCode} output/${ProcName}.sql.${yyyymmddHHMMSS}.${DBName} ${Password}

./searchReplace a_ ${ProductCode}_ output/${ProcName}.sql.${yyyymmddHHMMSS}.${DBName} ${Password}
./searchReplace mrea area output/${ProcName}.sql.${yyyymmddHHMMSS}.${DBName} ${Password}
./searchReplace wrea area output/${ProcName}.sql.${yyyymmddHHMMSS}.${DBName} ${Password}

${SQSH} -Ucron_sa -S${DBServer} -D${DBName} -i output/${ProcName}.sql.${yyyymmddHHMMSS}.${DBName} -o output/${ProcName}.out.${yyyymmddHHMMSS}.${DBName}.${DBServer}  -P${Password}

grep PROCEDURE output/${ProcName}.out.${yyyymmddHHMMSS}.${DBName}.${DBServer}

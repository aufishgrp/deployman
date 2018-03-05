#!/usr/bin/env bash

dir_resolve(){
	cd "${1}" 2>/dev/null || return $?  # cd to desired directory; if fail, quell any error messages but return exit status
	echo "`pwd -P`" # output full, link-resolved path
}

copy_files(){
	FILES="${1}"
	SUBDIR="${2:-}"
	for FILE in ${FILES[@]}; do
		TARGET=${DEPLOYMAN_ROOT}/${FILE}
		if [ "${FILE}" == "`basename ${FILE}`" ]; then
			TARGET=${FILE}
		fi
		if [ ! -d "`dirname ${TARGET}`" ]; then
			mkdir -p "`dirname ${TARGET}`"
		fi 
		if [ -f ${DEPLOYMAN_LANG_DIR}/${FILE} ]; then
			cp ${DEPLOYMAN_LANG_DIR}/${FILE} ${TARGET}
		elif [ -f ${DEPLOYMAN_DIR}/${FILE} ]; then
			cp ${DEPLOYMAN_DIR}/${FILE} ${TARGET}
		fi
	done
}

DEPLOYMAN_LANG=${1:-}
DEPLOYMAN_PROJECT=${2:-.}
DEPLOYMAN_ROOT=${DEPLOYMAN_PROJECT}/_deployman
DEPLOYMAN_LANG_DIR=${DEPLOYMAN_DIR}/lib/${DEPLOYMAN_LANG}

DEPLOYMAN_DIR=`dirname $0`
DEPLOYMAN_DIR="`dir_resolve ${DEPLOYMAN_DIR}/..`"
DEPLOYMAN_LANG_DIR=${DEPLOYMAN_DIR}/lib/${DEPLOYMAN_LANG}

if [ -d "${DEPLOYMAN_ROOT}" ]; then
	echo "Directory ${DEPLOYMAN_PROJECT} already initialized."
	exit 1
fi

if [ ! -d "${DEPLOYMAN_LANG_DIR}" ]; then
	echo "Profile \"${DEPLOYMAN_LANG}\" does not exist."
	exit 1
fi

## Copy root files
FILES=("Makefile" ".common.mk" ".travis.yml" "./README.md" "etc/commit-tag" "src/Dockerfile.devel" "src/Dockerfile.deploy" "bin/app-version.sh" "bin/ci-logic.sh" "bin/make-tools.sh" "bin/make-lint.sh")
copy_files ${FILES}

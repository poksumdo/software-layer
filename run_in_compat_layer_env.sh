#!/bin/bash
echo "is env var EASYBUILD_OPTARCH set?"
env | grep -i EASYBUILD_OPTARCH | sed -e 's/^/run_in_compat_layer.sh:/'
if [ -z $EESSI_PILOT_VERSION ]; then
    echo "ERROR: \$EESSI_PILOT_VERSION must be set!" >&2
    exit 1
fi
EESSI_COMPAT_LAYER_DIR="/cvmfs/pilot.nessi.uiocloud.no/versions/${EESSI_PILOT_VERSION}/compat/linux/$(uname -m)"
if [ ! -d ${EESSI_COMPAT_LAYER_DIR} ]; then
    echo "ERROR: ${EESSI_COMPAT_LAYER_DIR} does not exist!" >&2
    exit 1
fi

INPUT=$(echo "$@")
if [ ! -z ${EESSI_SOFTWARE_SUBDIR_OVERRIDE} ]; then
    INPUT="export EESSI_SOFTWARE_SUBDIR_OVERRIDE=${EESSI_SOFTWARE_SUBDIR_OVERRIDE}; ${INPUT}"
fi

echo "Running '${INPUT}' in EESSI ${EESSI_PILOT_VERSION} compatibility layer environment..."
${EESSI_COMPAT_LAYER_DIR}/startprefix <<< "${INPUT}"

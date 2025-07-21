run_command() {
    if ! "$@"; then
        echo "Error: Command failed: $*"
        exit 1
    fi
}

raw_dataset_dir=Bicycle
dataset_dir=processes/Bicycle

processing_flags="--sfm-tool hloc --matcher-type superpoint+lightglue --num-downscales 2 --matching-method vocab_tree"
run_command ns-process-data images --data "${raw_dataset_dir}/input" --output_dir "${dataset_dir}" ${processing_flags}
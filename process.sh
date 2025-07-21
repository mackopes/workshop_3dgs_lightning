run_command() {
    if ! "$@"; then
        echo "Error: Command failed: $*"
        exit 1
    fi
}

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is required."
    exit 1
fi

# Load config
if [ ! -f "config.yaml" ]; then
    echo "Error: config.yaml not found!"
    exit 1
fi

raw_dataset_dir=$(yq '.dataset_path' config.yaml)
dataset_dir=$(yq '.processed' config.yaml)

# Check required fields
if [ "$raw_dataset_dir" = "null" ] || [ "$raw_dataset_dir" = "" ] || [ "$dataset_dir" = "null" ] || [ "$dataset_dir" = "" ]; then
    echo "Error: Please fill in dataset_path and processed fields in config.yaml"
    exit 1
fi

processing_flags="--sfm-tool hloc --matcher-type superpoint+lightglue --num-downscales 2 --matching-method vocab_tree"
run_command ns-process-data images --data "${raw_dataset_dir}/input" --output_dir "${dataset_dir}" ${processing_flags}
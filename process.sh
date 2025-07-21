run_command() {
    if ! "$@"; then
        echo "Error: Command failed: $*"
        exit 1
    fi
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Function to normalize directory paths (remove trailing slash if present)
normalize_path() {
    local path="$1"
    echo "${path%/}"
}

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is required."
    exit 1
fi

# Load config from script directory
CONFIG_FILE="${SCRIPT_DIR}/config.yaml"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.yaml not found in script directory: $SCRIPT_DIR"
    exit 1
fi

raw_dataset_dir=$(yq '.dataset_path' "$CONFIG_FILE")
dataset_dir=$(yq '.processed_path' "$CONFIG_FILE")

# Check required fields
if [ "$raw_dataset_dir" = "null" ] || [ "$raw_dataset_dir" = "" ] || [ "$dataset_dir" = "null" ] || [ "$dataset_dir" = "" ]; then
    echo "Error: Please fill in dataset_path and processed_path fields in config.yaml"
    exit 1
fi

# Normalize paths (remove trailing slashes)
raw_dataset_dir=$(normalize_path "$raw_dataset_dir")
dataset_dir=$(normalize_path "$dataset_dir")

processing_flags="--sfm-tool hloc --matcher-type superpoint+lightglue --num-downscales 2 --matching-method vocab_tree"
run_command ns-process-data images --data "${raw_dataset_dir}/input" --output_dir "${dataset_dir}" ${processing_flags}
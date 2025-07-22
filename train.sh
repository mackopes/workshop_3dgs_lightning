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

export MAX_JOBS=2

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is required. Install with: brew install yq (or snap install yq on Linux)"
    exit 1
fi

# Load config from script directory
CONFIG_FILE="${SCRIPT_DIR}/config.yaml"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.yaml not found in script directory: $SCRIPT_DIR"
    exit 1
fi

method_name="splatfacto"
dataset_dir=$(yq '.processed_path' "$CONFIG_FILE")
models_dir=$(yq '.model_path' "$CONFIG_FILE")
experiment_name=default

# Check required fields
if [ "$dataset_dir" = "null" ] || [ "$dataset_dir" = "" ] || [ "$models_dir" = "null" ] || [ "$models_dir" = "" ]; then
    echo "Error: Please fill in processed_path and model_path fields in config.yaml"
    exit 1
fi

# Normalize paths (remove trailing slashes)
dataset_dir=$(normalize_path "$dataset_dir")
models_dir=$(normalize_path "$models_dir")

training_flags="--pipeline.model.sh-degree 0 --viewer.quit-on-train-completion True --pipeline.model.camera-optimizer.mode SO3xR3"


run_command ns-train "${method_name}" --data "${dataset_dir}/" --output-dir ${models_dir} --experiment-name "${experiment_name}" --method-name "${method_name}" --timestamp "default" ${training_flags}

run_command ns-export gaussian-splat --load-config "${models_dir}/default/${method_name}/default/config.yml" --output-dir "${models_dir}/default/${method_name}/default"
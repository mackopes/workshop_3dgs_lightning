run_command() {
    if ! "$@"; then
        echo "Error: Command failed: $*"
        exit 1
    fi
}

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is required. Install with: brew install yq (or snap install yq on Linux)"
    exit 1
fi

# Load config
if [ ! -f "config.yaml" ]; then
    echo "Error: config.yaml not found!"
    exit 1
fi

method_name="splatfacto"
dataset_dir=$(yq '.processed' config.yaml)
models_dir=$(yq '.model_path' config.yaml)
experiment_name=default

# Check required fields
if [ "$dataset_dir" = "null" ] || [ "$dataset_dir" = "" ] || [ "$models_dir" = "null" ] || [ "$models_dir" = "" ]; then
    echo "Error: Please fill in processed and model_path fields in config.yaml"
    exit 1
fi

training_flags="--pipeline.model.sh-degree 0 --viewer.quit-on-train-completion True --pipeline.model.camera-optimizer.mode SO3xR3"


run_command ns-train "${method_name}" --data "${dataset_dir}/" --output-dir ${models_dir} --experiment-name "${experiment_name}" --method-name "${method_name}" --timestamp "default" ${training_flags}

run_command ns-export gaussian-splat --load-config "${models_dir}/default/${method_name}/config.yml" --output-dir "${models_dir}/default/${method_name}/default"
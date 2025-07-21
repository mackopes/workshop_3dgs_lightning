run_command() {
    if ! "$@"; then
        echo "Error: Command failed: $*"
        exit 1
    fi
}

method_name="splatfacto"
dataset_dir=processes/Bicycle
models_dir=models/Bicycle
experiment_name=default

training_flags="--pipeline.model.sh-degree 0 --viewer.quit-on-train-completion True --pipeline.model.camera-optimizer.mode SO3xR3"


run_command ns-train "${method_name}" --data "${dataset_dir}/" --output-dir ${models_dir} --experiment-name "${experiment_name}" --method-name "${method_name}" --timestamp "default" ${training_flags}

run_command ns-export gaussian-splat --load-config "${model_dir}/${method_name}/default/config.yml" --output-dir "${model_dir}/${method_name}/default"
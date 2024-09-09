{ config, pkgs, ... }:
{
  nixpkgs.config = {
    nvidia.acceptLicense = true;
  };
  virtualisation.docker = {
    # https://docs.docker.com/reference/cli/dockerd/#enable-cdi-devices
    daemon.settings.features.cdi = true;
  };
  # This uses the updated CDI https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/cdi-support.html
  # Normal `docker run` usage is the following:
  # docker run --rm -it --device=nvidia.com/gpu=all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark
  # not `docker run --rm -it --gpus=all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark`
  # also https://www.docker.com/blog/docker-nvidia-support-building-running-ai-ml-apps/
  # https://docs.docker.com/reference/cli/dockerd/#enable-cdi-devices
  # looks like this is still an experimental feature
  # also an interesting resource https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/cdi.html
  hardware.nvidia-container-toolkit.enable = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    # https://docs.aws.amazon.com/dlami/latest/devguide/appendix-ami-release-notes.html
    # https://aws.amazon.com/releasenotes/aws-deep-learning-base-gpu-ami-ubuntu-22-04/
    # ^ Shows that AWS AMIs use 535 drivers. Unsure if these can be upgraded alghough I don't see why not
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.dc_535;
    nvidiaPersistenced = true;
    modesetting.enable = true;
    datacenter.enable = true;
    open = false;

  };
  environment.systemPackages = with pkgs; [
    # ollama-cuda # wasn't cached and took forever to build
    nvtopPackages.nvidia
    cudaPackages.cudatoolkit
  ];
}

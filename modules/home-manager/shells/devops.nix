{ pkgs }:

{
  name = "devops";
  fhs = false;
  targetPkgs = with pkgs; [
    ansible
    ansible-lint
    google-cloud-sdk
    kubernetes-helm
    kubectl
    kubetail
    minikube
    terraform
  ];
}

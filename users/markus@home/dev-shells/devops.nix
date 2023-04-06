{ pkgs }:

{
  name = "devops";
  fhs = false;
  targetPkgs = with pkgs; [
    ansible
    ansible-lint
    google-cloud-sdk
    hey
    kubernetes-helm
    kubectl
    kubetail
    minikube
    terraform
  ];
}

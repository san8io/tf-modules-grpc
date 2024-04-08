# EKS module

This EKS cluster module includes the necessary configuration for plugins like vpc-cni for pod discovery through private IPs, an AWS managed node group with SPOT instances for costs optimization, a custom IAM role for service connection with access to AWS ECR and AWS Route53.

Helm charts confugured:
- [cert-manager](https://github.com/cert-manager/cert-manager) for SSL termination and secure intra cluster comunication.
- [alb-controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller) for ingress management and L7 load balancing.
- [external-dns](https://github.com/kubernetes-sigs/external-dns) for DNS records management integrated with AWS Route53.
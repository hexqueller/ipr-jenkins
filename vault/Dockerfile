FROM vault:1.13.3

ENV VAULT_LOCAL_CONFIG=/vault/config.hcl

COPY config.hcl /vault/config.hcl
COPY init.sh /vault/init.sh
COPY jenkins-policy.hcl /vault/jenkins-policy.hcl

CMD sh -c "vault server -config=/vault/config.hcl & sleep 5 && sh /vault/init.sh; tail -f /dev/null"
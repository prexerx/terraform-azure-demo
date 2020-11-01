
t?=$(error "Please input a valid target, example: make plan t=xxx.tf")

init:
	terraform init
plan:
	@echo "your target is : [$(t)]"
	terraform plan -out ./$(t).plan
dplan:
	terraform plan -destroy -out ./$(t).d.plan
apply:
	terraform apply ./$(t).plan
dapply:
	terraform apply ./$(t).d.plan

clean:
	rm -f *.plan
clean-statefile: clean
	rm -f statefile/*.terraform.*
clean-all: clean-statefile
	rm -rf .terraform/

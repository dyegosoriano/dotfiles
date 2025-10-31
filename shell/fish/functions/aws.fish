function aws_log --description 'Seleciona ambiente e task para dar tail em logs da AWS.'
  set -l tasks_prod prod-authentication prod-communications prod-localizations prod-tax-invoice prod-marketplace prod-payments prod-parking prod-gateway prod-coupons prod-events job-worker
  set -l tasks_dev Communications Authentication Localizations Marketplace TaxInvoice JobWorker Payments Gateway Parking Coupons Events Elixir

  set -l aws_profile (printf "gen-prod\ngen-dev" | fzf --prompt='Selecione o ambiente: ')
  set -l region "us-east-2"
  set selected_task
  clear

  if not set -q aws_profile
    echo "Seleção de ambiente cancelada."
    return 1
  end

  switch "$aws_profile"
    case "gen-prod"
      set task_prod (printf "%s\n" $tasks_prod | fzf --prompt='Selecione a task/log-group: ')
      set selected_task "/ecs/"$task_prod"-task-def"
    case "gen-dev"
      set task_dev (printf "%s\n" $tasks_dev | fzf --prompt='Selecione a task/log-group: ')
      set selected_task "/ecs/Dev"$task_dev"TaskDef"
    case "*"
      echo "Erro: Ambiente '$environment' não reconhecido."
      return 1
  end

  if not set -q selected_task
    echo "Seleção de task cancelada."
    return 1
  end

  echo "Comando: aws logs tail $selected_task --follow --profile $aws_profile --region $region"
  echo "Pressione Ctrl+C para parar o tail."

  aws logs tail $selected_task \
    --profile $aws_profile \
    --region $region \
    --follow
end

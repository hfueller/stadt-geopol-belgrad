// Quarto post-render: ruft das Shell-Skript über bash auf.
// So ist kein Ausführungsrecht (chmod +x) auf der .sh-Datei nötig.
const dir = Deno.env.get("QUARTO_PROJECT_DIR") ?? Deno.cwd();
const { code } = await new Deno.Command("/bin/bash", {
  args: [`${dir}/scripts/git-autopush.sh`],
  cwd: dir,
  stdout: "inherit",
  stderr: "inherit",
}).output();
if (code !== 0) console.warn(`git-autopush beendet mit Code ${code}`);

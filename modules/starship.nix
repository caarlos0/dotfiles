{ ... }:
{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      cmd_duration = {
        min_time = 500;
        format = "[$duration]($style) ";
      };
      git_branch.symbol = " ";
      git_status.format = "[$ahead_behind$untracked$modified]($style) ";
      directory = {
        read_only = " ";
        truncate_to_repo = false;
      };
      username.format = "[$user]($style)";
      hostname = {
        ssh_symbol = "@";
        format = "$ssh_symbol[$hostname](bright-blue) ";
      };

      aws.disabled = true;
      azure.disabled = true;
      buf.disabled = true;
      bun.disabled = true;
      c.disabled = true;
      cmake.disabled = true;
      conda.disabled = true;
      container.disabled = true;
      crystal.disabled = true;
      daml.disabled = true;
      dart.disabled = true;
      deno.disabled = true;
      docker_context.disabled = true;
      dotnet.disabled = true;
      elixir.disabled = true;
      elm.disabled = true;
      env_var.disabled = true;
      erlang.disabled = true;
      fennel.disabled = true;
      gcloud.disabled = true;
      golang.disabled = true;
      gradle.disabled = true;
      guix_shell.disabled = true;
      haskell.disabled = true;
      haxe.disabled = true;
      helm.disabled = true;
      java.disabled = true;
      jobs.disabled = true;
      julia.disabled = true;
      kotlin.disabled = true;
      kubernetes.disabled = true;
      lua.disabled = true;
      nim.disabled = true;
      nix_shell.disabled = true;
      nodejs.disabled = true;
      ocaml.disabled = true;
      openstack.disabled = true;
      package.disabled = true;
      perl.disabled = true;
      php.disabled = true;
      purescript.disabled = true;
      python.disabled = true;
      ruby.disabled = true;
      rust.disabled = true;
      scala.disabled = true;
      shlvl.disabled = true;
      singularity.disabled = true;
      swift.disabled = true;
      terraform.disabled = true;
      vagrant.disabled = true;
      zig.disabled = true;
    };
  };
  programs.fish.interactiveShellInit = "
    function starship_transient_prompt_func
      echo
      starship module character
    end
  ";
}



usethis::use_git()

usethis::use_github()

usethis::use_readme_rmd()

usethis::browse_github()


# Start LM Studio if needed (if terminal already in use, close terminal panel and run again)
terminal_id = rstudiotools::terminal(".\\StartLMstudio.ps1",caption="Claude")
# Start Claude Code if needed
terminal_id = rstudiotools::terminal("claude --model qwen/qwen3.5-9b",terminal_id = terminal_id)

# prompt = "Review the project and update claude.md to reflect the current architecture and recent changes."
# terminal_id = rstudiotools::terminal(prompt, terminal_id = terminal_id)

terminal_id = rstudiotools::terminal("qual a capital de El Salvador ?", terminal_id = terminal_id)










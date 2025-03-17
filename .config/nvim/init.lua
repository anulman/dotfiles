vim.cmd [[
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
  source ~/.vimrc
]]

-- Install parrot
require('parrot').setup({
  toggle_target = 'tabnew',
  providers = {
    anthropic = {
      api_key = os.getenv 'ANTHROPIC_API_KEY'
    }
  },
  hooks = {
    Complete = function(prt, params)
      local template = [[
      I have the following code from {{filename}}:

      ```{{filetype}}
      {{selection}}
      ```

      Please finish the code above carefully and logically.
      Respond just with the snippet of code that should be inserted."
      ]]
      local model_obj = prt.get_model "command"
      prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
    end,
    CompleteFullContext = function(prt, params)
      local template = [[
      I have the following code from {{filename}}:

      ```{{filetype}}
      {{filecontent}}
      ```

      Please look at the following section specifically:
      ```{{filetype}}
      {{selection}}
      ```

      Please finish the code above carefully and logically.
      Respond just with the snippet of code that should be inserted.
      ]]
      local model_obj = prt.get_model "command"
      prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
    end,
    CompleteMultiContext = function(prt, params)
      local template = [[
      I have the following code from {{filename}} and other related files:

      ```{{filetype}}
      {{multifilecontent}}
      ```

      Please look at the following section specifically:
      ```{{filetype}}
      {{selection}}
      ```

      Please finish the code above carefully and logically.
      Respond just with the snippet of code that should be inserted.
      ]]
      local model_obj = prt.get_model "command"
      prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
    end,
    Explain = function(prt, params)
      local template = [[
      Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
      Break down the code's functionality, purpose, and key components.
      The goal is to help the reader understand what the code does and how it works.

      ```{{filetype}}
      {{selection}}
      ```

      Use the markdown format with codeblocks and inline code.
      Explanation of the code above:
      ]]
      local model = prt.get_model "command"
      prt.logger.info("Explaining selection with model: " .. model.name)
      prt.Prompt(params, prt.ui.Target.new, model, nil, template)
    end,
    ExplainFullContext = function(prt, params)
      local template = [[
      Your task is to take the code from {{filename}} and explain it in detail with its full context.
      Break down the code's functionality, purpose, and key components within the larger file.
      The goal is to help the reader understand what the code does and how it works in relation to the entire file.

      Full file content:
      ```{{filetype}}
      {{filecontent}}
      ```

      Please focus on this specific section:
      ```{{filetype}}
      {{selection}}
      ```

      Use the markdown format with codeblocks and inline code.
      Explanation of the code with its full context:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Explaining selection with full context using model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
    end,
    ExplainMultiContext = function(prt, params)
      local template = [[
      Your task is to take the code from {{filename}} and explain it in detail with context from multiple related files.
      Break down the code's functionality, purpose, and key components within the larger codebase.
      The goal is to help the reader understand what the code does and how it works in relation to the entire project.

      Full context from multiple files:
      ```{{filetype}}
      {{multifilecontent}}
      ```

      Please focus on this specific section:
      ```{{filetype}}
      {{selection}}
      ```

      Use the markdown format with codeblocks and inline code.
      Explanation of the code with its multi-file context:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Explaining selection with multi-file context using model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
    end,
    Optimize = function(prt, params)
      local template = [[
      You are an expert in {{filetype}}.
      Your task is to analyze the provided {{filetype}} code snippet and
      suggest improvements to optimize its performance. Identify areas
      where the code can be made more efficient, faster, or less
      resource-intensive. Provide specific suggestions for optimization,
      along with explanations of how these changes can enhance the code's
      performance. The optimized code should maintain the same functionality
      as the original code while demonstrating improved efficiency.

      ```{{filetype}}
      {{selection}}
      ```

      Optimized code:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Optimizing selection with model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
    end,
    OptimizeFullContext = function(prt, params)
      local template = [[
      You are an expert in {{filetype}}.
      Your task is to analyze the provided {{filetype}} code snippet within its full file context and
      suggest improvements to optimize its performance. Identify areas
      where the code can be made more efficient, faster, or less
      resource-intensive. Provide specific suggestions for optimization,
      along with explanations of how these changes can enhance the code's
      performance. The optimized code should maintain the same functionality
      as the original code while demonstrating improved efficiency.

      Full file content:
      ```{{filetype}}
      {{filecontent}}
      ```

      Please focus on this specific section:
      ```{{filetype}}
      {{selection}}
      ```

      Optimized code:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Optimizing selection with full context using model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
    end,
    OptimizeMultiContext = function(prt, params)
      local template = [[
      You are an expert in {{filetype}}.
      Your task is to analyze the provided {{filetype}} code snippet within the context of multiple related files and
      suggest improvements to optimize its performance. Identify areas
      where the code can be made more efficient, faster, or less
      resource-intensive. Provide specific suggestions for optimization,
      along with explanations of how these changes can enhance the code's
      performance. The optimized code should maintain the same functionality
      as the original code while demonstrating improved efficiency.

      Full context from multiple files:
      ```{{filetype}}
      {{multifilecontent}}
      ```

      Please focus on this specific section:
      ```{{filetype}}
      {{selection}}
      ```

      Optimized code:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Optimizing selection with multi-file context using model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
    end,
    Debug = function(prt, params)
      local template = [[
      I want you to act as {{filetype}} expert.
      Review the following code, carefully examine it, and report potential
      bugs and edge cases alongside solutions to resolve them.
      Keep your explanation short and to the point:

      ```{{filetype}}
      {{selection}}
      ```
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Debugging selection with model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
    end,
    DebugFullContext = function(prt, params)
      local template = [[
      I want you to act as {{filetype}} expert.
      Review the following code within its full file context, carefully examine it, and report potential
      bugs and edge cases alongside solutions to resolve them.
      Keep your explanation short and to the point:

      Full file content:
      ```{{filetype}}
      {{filecontent}}
      ```

      Please focus on this specific section:
      ```{{filetype}}
      {{selection}}
      ```
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Debugging selection with full context using model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
    end,
    DebugMultiContext = function(prt, params)
      local template = [[
      I want you to act as {{filetype}} expert.
      Review the following code within the context of multiple related files, carefully examine it, and report potential
      bugs and edge cases alongside solutions to resolve them.
      Keep your explanation short and to the point:

      Full context from multiple files:
      ```{{filetype}}
      {{multifilecontent}}
      ```

      Please focus on this specific section:
      ```{{filetype}}
      {{selection}}
      ```
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Debugging selection with multi-file context using model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
    end,
    FixBugs = function(prt, params)
      local template = [[
      You are an expert in {{filetype}}.
      Fix bugs in the below code from {{filename}} carefully and logically:
      Your task is to analyze the provided {{filetype}} code snippet, identify
      any bugs or errors present, and provide a corrected version of the code
      that resolves these issues. Explain the problems you found in the
      original code and how your fixes address them. The corrected code should
      be functional, efficient, and adhere to best practices in
      {{filetype}} programming.

      ```{{filetype}}
      {{selection}}
      ```

      Fixed code:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Fixing bugs in selection with model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
    end,
    FixBugsFullContext = function(prt, params)
      local template = [[
      You are an expert in {{filetype}}.
      Fix bugs in the below code from {{filename}} carefully and logically:
      Your task is to analyze the provided {{filetype}} code snippet within its
      full file context, identify any bugs or errors present, and provide a
      corrected version of the code that resolves these issues. Explain the
      problems you found in the original code and how your fixes address them.
      The corrected code should be functional, efficient, and adhere to best
      practices in {{filetype}} programming.

      Full file content:
      ```{{filetype}}
      {{filecontent}}
      ```

      Please focus on this specific section:
      ```{{filetype}}
      {{selection}}
      ```

      Fixed code:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Fixing bugs in selection with full context using model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
    end,
    FixBugsMultiContext = function(prt, params)
      local template = [[
      You are an expert in {{filetype}}.
      Fix bugs in the below code from {{filename}} carefully and logically:
      Your task is to analyze the provided {{filetype}} code snippet within the
      context of multiple related files, identify any bugs or errors present,
      and provide a corrected version of the code that resolves these issues.
      Explain the problems you found in the original code and how your fixes
      address them. The corrected code should be functional, efficient, and
      adhere to best practices in {{filetype}} programming.

      Full context from multiple files:
      ```{{filetype}}
      {{multifilecontent}}
      ```

      Please focus on this specific section:
      ```{{filetype}}
      {{selection}}
      ```

      Fixed code:
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Fixing bugs in selection with multi-file context using model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
    end,
    UnitTests = function(prt, params)
      local template = [[
      I have the following code from {{filename}}:

      ```{{filetype}}
      {{selection}}
      ```

      Please respond by writing table driven unit tests for the code above.
      ]]
      local model_obj = prt.get_model "command"
      prt.logger.info("Creating unit tests for selection with model: " .. model_obj.name)
      prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
    end,
    CommitMsg = function(prt, params)
      local futils = require "parrot.file_utils"
      if futils.find_git_root() == "" then
        prt.logger.warning "Not in a git repository"
        return
      else
        local template = [[
        I want you to act as a commit message generator. I will provide you
        with information about the task and the prefix for the task code, and
        I would like you to generate an appropriate commit message using the
        conventional commit format. Do not write any explanations or other
        words, just reply with the commit message.
        Start with a short headline as summary but then list the individual
        changes in more detail.

        Here are the changes that should be considered by this message:
        ]] .. vim.fn.system "git diff --no-color --no-ext-diff --staged"
        local model_obj = prt.get_model "command"
        prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
      end
    end,
  }
})

vim.cmd [[
  " In visual mode, <leader>pp should :PrtChatPaste
  " In normal mode, <leader>pp should :PrtChatToggle
  vnoremap <leader>pp :PrtChatPaste<CR>
  nnoremap <leader>pp :PrtChatToggle<CR>

  " In visual mode, <leader>pn should :PrtChatPaste after :PrtChatNew
  " In normal mode, <leader>pn should only :PrtChatNew
  vnoremap <leader>pn :PrtChatNew<CR>:PrtChatPaste<CR>
  nnoremap <leader>pn :PrtChatNew<CR>

  nnoremap <leader>p<CR> :PrtChatRespond<CR>
  nnoremap <C-CR> :PrtChatRespond<CR>
  nnoremap <leader>p<leader> :PrtChatRespond<CR>

  nnoremap <leader>po :PrtChatFinder<CR>
  nnoremap <leader>pt :PrtThinking<CR>
  nnoremap <leader>pd :PrtChatDelete<CR>

  vnoremap <leader>pc :PrtComplete<CR>
  vnoremap <leader>pcc :PrtCompleteFullContext<CR>
  vnoremap <leader>pccc :PrtCompleteMultiContext<CR>

  vnoremap <leader>pe :PrtExplain<CR>
  vnoremap <leader>pee :PrtExplainFullContext<CR>
  vnoremap <leader>peee :PrtExplainMultiContext<CR>

  vnoremap <leader>pf :PrtFixBugs<CR>
  vnoremap <leader>pff :PrtFixBugsFullContext<CR>
  vnoremap <leader>pfff :PrtFixBugsMultiContext<CR>

  vnoremap <leader>pr :PrtOptimize<CR>
  vnoremap <leader>prr :PrtOptimizeFullContext<CR>
  vnoremap <leader>prrr :PrtOptimizeMultiContext<CR>

  vnoremap <leader>pd :PrtDebug<CR>
  vnoremap <leader>pdd :PrtDebugFullContext<CR>
  vnoremap <leader>pddd :PrtDebugMultiContext<CR>

  vnoremap <leader>pt :PrtUnitTests<CR>
  nnoremap <leader>pg :PrtCommitMsg<CR>
]]

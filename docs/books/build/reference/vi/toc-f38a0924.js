// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="index.html">Giới Thiệu</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 1: CLI Reference</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/cli/overview.html"><strong aria-hidden="true">1.</strong> dev-team CLI</a><a class="chapter-fold-toggle"><div>❱</div></a></span><ol class="section"><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/cli/install.html"><strong aria-hidden="true">1.1.</strong> install</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/cli/update.html"><strong aria-hidden="true">1.2.</strong> update</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/cli/list.html"><strong aria-hidden="true">1.3.</strong> list</a></span></li></ol><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/cli/environment.html"><strong aria-hidden="true">2.</strong> Environment Variables</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/cli/exit-codes.html"><strong aria-hidden="true">3.</strong> Exit Codes</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 2: Agent Specification</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/format.html"><strong aria-hidden="true">4.</strong> Agent Format</a><a class="chapter-fold-toggle"><div>❱</div></a></span><ol class="section"><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/frontmatter.html"><strong aria-hidden="true">4.1.</strong> YAML Frontmatter Fields</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/required-fields.html"><strong aria-hidden="true">4.2.</strong> Required Fields</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/optional-fields.html"><strong aria-hidden="true">4.3.</strong> Optional Fields</a></span></li></ol><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/body.html"><strong aria-hidden="true">5.</strong> Body Structure</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools.html"><strong aria-hidden="true">6.</strong> Tools Reference</a><a class="chapter-fold-toggle"><div>❱</div></a></span><ol class="section"><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/read.html"><strong aria-hidden="true">6.1.</strong> Read</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/write.html"><strong aria-hidden="true">6.2.</strong> Write</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/edit.html"><strong aria-hidden="true">6.3.</strong> Edit</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/bash.html"><strong aria-hidden="true">6.4.</strong> Bash</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/glob.html"><strong aria-hidden="true">6.5.</strong> Glob</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/grep.html"><strong aria-hidden="true">6.6.</strong> Grep</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/webfetch.html"><strong aria-hidden="true">6.7.</strong> WebFetch</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/websearch.html"><strong aria-hidden="true">6.8.</strong> WebSearch</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/lsp.html"><strong aria-hidden="true">6.9.</strong> LSP</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/todowrite.html"><strong aria-hidden="true">6.10.</strong> TodoWrite</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/tools/askuserquestion.html"><strong aria-hidden="true">6.11.</strong> AskUserQuestion</a></span></li></ol><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/models.html"><strong aria-hidden="true">7.</strong> Models</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/permission-modes.html"><strong aria-hidden="true">8.</strong> Permission Modes</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/agent-spec/validation.html"><strong aria-hidden="true">9.</strong> Validation Rules</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 3: Skill Specification</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/skill-spec/format.html"><strong aria-hidden="true">10.</strong> Skill Format</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/skill-spec/skill-file.html"><strong aria-hidden="true">11.</strong> SKILL.md Structure</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/skill-spec/reference-files.html"><strong aria-hidden="true">12.</strong> Reference Files</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/skill-spec/validation.html"><strong aria-hidden="true">13.</strong> Validation Rules</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 4: Team Specification</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/team-spec/format.html"><strong aria-hidden="true">14.</strong> Team Format</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/team-spec/directory.html"><strong aria-hidden="true">15.</strong> Directory Structure</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/team-spec/workflow.html"><strong aria-hidden="true">16.</strong> workflow.md</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/team-spec/team-memory.html"><strong aria-hidden="true">17.</strong> team-memory/</a><a class="chapter-fold-toggle"><div>❱</div></a></span><ol class="section"><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/team-spec/memory/context.html"><strong aria-hidden="true">17.1.</strong> context.md</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/team-spec/memory/decisions.html"><strong aria-hidden="true">17.2.</strong> decisions.md</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/team-spec/memory/handoffs.html"><strong aria-hidden="true">17.3.</strong> handoffs.md</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/team-spec/memory/blockers.html"><strong aria-hidden="true">17.4.</strong> blockers.md</a></span></li></ol><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/team-spec/handoff-protocol.html"><strong aria-hidden="true">18.</strong> Handoff Protocol</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/team-spec/dispatch-protocol.html"><strong aria-hidden="true">19.</strong> Dispatch Protocol</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 5: Command Specification</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/command-spec/format.html"><strong aria-hidden="true">20.</strong> Command Format</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/command-spec/naming.html"><strong aria-hidden="true">21.</strong> Naming Conventions</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/command-spec/at-references.html"><strong aria-hidden="true">22.</strong> @ References</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 6: Hooks API</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/configuration.html"><strong aria-hidden="true">23.</strong> Hook Configuration</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/matchers.html"><strong aria-hidden="true">24.</strong> Matchers</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/types.html"><strong aria-hidden="true">25.</strong> Hook Types</a><a class="chapter-fold-toggle"><div>❱</div></a></span><ol class="section"><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/pre-tool-use.html"><strong aria-hidden="true">25.1.</strong> PreToolUse</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/post-tool-use.html"><strong aria-hidden="true">25.2.</strong> PostToolUse</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/user-prompt-submit.html"><strong aria-hidden="true">25.3.</strong> UserPromptSubmit</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/session-start.html"><strong aria-hidden="true">25.4.</strong> SessionStart</a></span></li></ol><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/input-schema.html"><strong aria-hidden="true">26.</strong> Input Schema</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/exit-codes.html"><strong aria-hidden="true">27.</strong> Exit Codes</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/hooks-api/templates.html"><strong aria-hidden="true">28.</strong> Script Templates</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 7: Knowledge System</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/knowledge-api/index-schema.html"><strong aria-hidden="true">29.</strong> knowledge-index.yaml Schema</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/knowledge-api/auto-loading.html"><strong aria-hidden="true">30.</strong> Auto-loading Rules</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/knowledge-api/keyword-triggers.html"><strong aria-hidden="true">31.</strong> Keyword Triggers</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/knowledge-api/phase-loading.html"><strong aria-hidden="true">32.</strong> Phase-based Loading</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 8: Memory System</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/memory-api/files.html"><strong aria-hidden="true">33.</strong> Memory Files</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/memory-api/context-format.html"><strong aria-hidden="true">34.</strong> context.md Format</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/memory-api/decisions-format.html"><strong aria-hidden="true">35.</strong> decisions.md Format</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/memory-api/learnings-format.html"><strong aria-hidden="true">36.</strong> learnings.md Format</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/memory-api/checkpoint-format.html"><strong aria-hidden="true">37.</strong> Checkpoint Format</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 9: Configuration</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/config/settings-json.html"><strong aria-hidden="true">38.</strong> settings.json</a><a class="chapter-fold-toggle"><div>❱</div></a></span><ol class="section"><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/config/permissions.html"><strong aria-hidden="true">38.1.</strong> permissions</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/config/hooks.html"><strong aria-hidden="true">38.2.</strong> hooks</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/config/env.html"><strong aria-hidden="true">38.3.</strong> env</a></span></li></ol><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/config/settings-local.html"><strong aria-hidden="true">39.</strong> settings.local.json</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/config/claude-md.html"><strong aria-hidden="true">40.</strong> CLAUDE.md</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 10: MicroAI Adapter Specification</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/adapter-spec/architecture.html"><strong aria-hidden="true">41.</strong> Architecture</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/adapter-spec/compliance-levels.html"><strong aria-hidden="true">42.</strong> Compliance Levels</a><a class="chapter-fold-toggle"><div>❱</div></a></span><ol class="section"><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/adapter-spec/level-1.html"><strong aria-hidden="true">42.1.</strong> Level 1: Minimal</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/adapter-spec/level-2.html"><strong aria-hidden="true">42.2.</strong> Level 2: Standard</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/adapter-spec/level-3.html"><strong aria-hidden="true">42.3.</strong> Level 3: Full</a></span></li></ol><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/adapter-spec/tool-abstraction.html"><strong aria-hidden="true">43.</strong> Tool Abstraction</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/adapter-spec/permission-model.html"><strong aria-hidden="true">44.</strong> Permission Model</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/adapter-spec/implementation.html"><strong aria-hidden="true">45.</strong> Implementation Guide</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/adapter-spec/compliance-checklist.html"><strong aria-hidden="true">46.</strong> Compliance Checklist</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 11: Built-in Agents Reference</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in/father-agent.html"><strong aria-hidden="true">47.</strong> father-agent</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in/npm-agent.html"><strong aria-hidden="true">48.</strong> npm-agent</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in/go-dev.html"><strong aria-hidden="true">49.</strong> go-dev-portable</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in/go-refactor.html"><strong aria-hidden="true">50.</strong> go-refactor-portable</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in/deep-question.html"><strong aria-hidden="true">51.</strong> deep-question-agent</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phần 12: Built-in Teams Reference</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/deep-thinking.html"><strong aria-hidden="true">52.</strong> deep-thinking-team</a><a class="chapter-fold-toggle"><div>❱</div></a></span><ol class="section"><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/deep-thinking/agents.html"><strong aria-hidden="true">52.1.</strong> Agents</a></span></li><li class="chapter-item "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/deep-thinking/workflow.html"><strong aria-hidden="true">52.2.</strong> Workflow</a></span></li></ol><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/dev-user.html"><strong aria-hidden="true">53.</strong> dev-user</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/dev-architect.html"><strong aria-hidden="true">54.</strong> dev-architect</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/dev-qa.html"><strong aria-hidden="true">55.</strong> dev-qa</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/dev-security.html"><strong aria-hidden="true">56.</strong> dev-security</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/pm-dev.html"><strong aria-hidden="true">57.</strong> pm-dev</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/dev-algo.html"><strong aria-hidden="true">58.</strong> dev-algo</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/go-team.html"><strong aria-hidden="true">59.</strong> go-team</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/mining-team.html"><strong aria-hidden="true">60.</strong> mining-team</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/deep-research.html"><strong aria-hidden="true">61.</strong> deep-research</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/built-in-teams/project-team.html"><strong aria-hidden="true">62.</strong> project-team</a></span></li><li class="chapter-item expanded "><li class="spacer"></li></li><li class="chapter-item expanded "><li class="part-title">Phụ Lục</li></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/appendix/yaml-schema.html"><strong aria-hidden="true">63.</strong> YAML Schema Reference</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/appendix/error-messages.html"><strong aria-hidden="true">64.</strong> Error Messages</a></span></li><li class="chapter-item expanded "><span class="chapter-link-wrapper"><a href="chapters/appendix/changelog.html"><strong aria-hidden="true">65.</strong> Changelog</a></span></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString().split('#')[0].split('?')[0];
        if (current_page.endsWith('/')) {
            current_page += 'index.html';
        }
        const links = Array.prototype.slice.call(this.querySelectorAll('a'));
        const l = links.length;
        for (let i = 0; i < l; ++i) {
            const link = links[i];
            const href = link.getAttribute('href');
            if (href && !href.startsWith('#') && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The 'index' page is supposed to alias the first chapter in the book.
            if (link.href === current_page
                || i === 0
                && path_to_root === ''
                && current_page.endsWith('/index.html')) {
                link.classList.add('active');
                let parent = link.parentElement;
                while (parent) {
                    if (parent.tagName === 'LI' && parent.classList.contains('chapter-item')) {
                        parent.classList.add('expanded');
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', e => {
            if (e.target.tagName === 'A') {
                const clientRect = e.target.getBoundingClientRect();
                const sidebarRect = this.getBoundingClientRect();
                sessionStorage.setItem('sidebar-scroll-offset', clientRect.top - sidebarRect.top);
            }
        }, { passive: true });
        const sidebarScrollOffset = sessionStorage.getItem('sidebar-scroll-offset');
        sessionStorage.removeItem('sidebar-scroll-offset');
        if (sidebarScrollOffset !== null) {
            // preserve sidebar scroll position when navigating via links within sidebar
            const activeSection = this.querySelector('.active');
            if (activeSection) {
                const clientRect = activeSection.getBoundingClientRect();
                const sidebarRect = this.getBoundingClientRect();
                const currentOffset = clientRect.top - sidebarRect.top;
                this.scrollTop += currentOffset - parseFloat(sidebarScrollOffset);
            }
        } else {
            // scroll sidebar to current active section when navigating via
            // 'next/previous chapter' buttons
            const activeSection = document.querySelector('#mdbook-sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        const sidebarAnchorToggles = document.querySelectorAll('.chapter-fold-toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(el => {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define('mdbook-sidebar-scrollbox', MDBookSidebarScrollbox);


// ---------------------------------------------------------------------------
// Support for dynamically adding headers to the sidebar.

(function() {
    // This is used to detect which direction the page has scrolled since the
    // last scroll event.
    let lastKnownScrollPosition = 0;
    // This is the threshold in px from the top of the screen where it will
    // consider a header the "current" header when scrolling down.
    const defaultDownThreshold = 150;
    // Same as defaultDownThreshold, except when scrolling up.
    const defaultUpThreshold = 300;
    // The threshold is a virtual horizontal line on the screen where it
    // considers the "current" header to be above the line. The threshold is
    // modified dynamically to handle headers that are near the bottom of the
    // screen, and to slightly offset the behavior when scrolling up vs down.
    let threshold = defaultDownThreshold;
    // This is used to disable updates while scrolling. This is needed when
    // clicking the header in the sidebar, which triggers a scroll event. It
    // is somewhat finicky to detect when the scroll has finished, so this
    // uses a relatively dumb system of disabling scroll updates for a short
    // time after the click.
    let disableScroll = false;
    // Array of header elements on the page.
    let headers;
    // Array of li elements that are initially collapsed headers in the sidebar.
    // I'm not sure why eslint seems to have a false positive here.
    // eslint-disable-next-line prefer-const
    let headerToggles = [];
    // This is a debugging tool for the threshold which you can enable in the console.
    let thresholdDebug = false;

    // Updates the threshold based on the scroll position.
    function updateThreshold() {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        const windowHeight = window.innerHeight;
        const documentHeight = document.documentElement.scrollHeight;

        // The number of pixels below the viewport, at most documentHeight.
        // This is used to push the threshold down to the bottom of the page
        // as the user scrolls towards the bottom.
        const pixelsBelow = Math.max(0, documentHeight - (scrollTop + windowHeight));
        // The number of pixels above the viewport, at least defaultDownThreshold.
        // Similar to pixelsBelow, this is used to push the threshold back towards
        // the top when reaching the top of the page.
        const pixelsAbove = Math.max(0, defaultDownThreshold - scrollTop);
        // How much the threshold should be offset once it gets close to the
        // bottom of the page.
        const bottomAdd = Math.max(0, windowHeight - pixelsBelow - defaultDownThreshold);
        let adjustedBottomAdd = bottomAdd;

        // Adjusts bottomAdd for a small document. The calculation above
        // assumes the document is at least twice the windowheight in size. If
        // it is less than that, then bottomAdd needs to be shrunk
        // proportional to the difference in size.
        if (documentHeight < windowHeight * 2) {
            const maxPixelsBelow = documentHeight - windowHeight;
            const t = 1 - pixelsBelow / Math.max(1, maxPixelsBelow);
            const clamp = Math.max(0, Math.min(1, t));
            adjustedBottomAdd *= clamp;
        }

        let scrollingDown = true;
        if (scrollTop < lastKnownScrollPosition) {
            scrollingDown = false;
        }

        if (scrollingDown) {
            // When scrolling down, move the threshold up towards the default
            // downwards threshold position. If near the bottom of the page,
            // adjustedBottomAdd will offset the threshold towards the bottom
            // of the page.
            const amountScrolledDown = scrollTop - lastKnownScrollPosition;
            const adjustedDefault = defaultDownThreshold + adjustedBottomAdd;
            threshold = Math.max(adjustedDefault, threshold - amountScrolledDown);
        } else {
            // When scrolling up, move the threshold down towards the default
            // upwards threshold position. If near the bottom of the page,
            // quickly transition the threshold back up where it normally
            // belongs.
            const amountScrolledUp = lastKnownScrollPosition - scrollTop;
            const adjustedDefault = defaultUpThreshold - pixelsAbove
                + Math.max(0, adjustedBottomAdd - defaultDownThreshold);
            threshold = Math.min(adjustedDefault, threshold + amountScrolledUp);
        }

        if (documentHeight <= windowHeight) {
            threshold = 0;
        }

        if (thresholdDebug) {
            const id = 'mdbook-threshold-debug-data';
            let data = document.getElementById(id);
            if (data === null) {
                data = document.createElement('div');
                data.id = id;
                data.style.cssText = `
                    position: fixed;
                    top: 50px;
                    right: 10px;
                    background-color: 0xeeeeee;
                    z-index: 9999;
                    pointer-events: none;
                `;
                document.body.appendChild(data);
            }
            data.innerHTML = `
                <table>
                  <tr><td>documentHeight</td><td>${documentHeight.toFixed(1)}</td></tr>
                  <tr><td>windowHeight</td><td>${windowHeight.toFixed(1)}</td></tr>
                  <tr><td>scrollTop</td><td>${scrollTop.toFixed(1)}</td></tr>
                  <tr><td>pixelsAbove</td><td>${pixelsAbove.toFixed(1)}</td></tr>
                  <tr><td>pixelsBelow</td><td>${pixelsBelow.toFixed(1)}</td></tr>
                  <tr><td>bottomAdd</td><td>${bottomAdd.toFixed(1)}</td></tr>
                  <tr><td>adjustedBottomAdd</td><td>${adjustedBottomAdd.toFixed(1)}</td></tr>
                  <tr><td>scrollingDown</td><td>${scrollingDown}</td></tr>
                  <tr><td>threshold</td><td>${threshold.toFixed(1)}</td></tr>
                </table>
            `;
            drawDebugLine();
        }

        lastKnownScrollPosition = scrollTop;
    }

    function drawDebugLine() {
        if (!document.body) {
            return;
        }
        const id = 'mdbook-threshold-debug-line';
        const existingLine = document.getElementById(id);
        if (existingLine) {
            existingLine.remove();
        }
        const line = document.createElement('div');
        line.id = id;
        line.style.cssText = `
            position: fixed;
            top: ${threshold}px;
            left: 0;
            width: 100vw;
            height: 2px;
            background-color: red;
            z-index: 9999;
            pointer-events: none;
        `;
        document.body.appendChild(line);
    }

    function mdbookEnableThresholdDebug() {
        thresholdDebug = true;
        updateThreshold();
        drawDebugLine();
    }

    window.mdbookEnableThresholdDebug = mdbookEnableThresholdDebug;

    // Updates which headers in the sidebar should be expanded. If the current
    // header is inside a collapsed group, then it, and all its parents should
    // be expanded.
    function updateHeaderExpanded(currentA) {
        // Add expanded to all header-item li ancestors.
        let current = currentA.parentElement;
        while (current) {
            if (current.tagName === 'LI' && current.classList.contains('header-item')) {
                current.classList.add('expanded');
            }
            current = current.parentElement;
        }
    }

    // Updates which header is marked as the "current" header in the sidebar.
    // This is done with a virtual Y threshold, where headers at or below
    // that line will be considered the current one.
    function updateCurrentHeader() {
        if (!headers || !headers.length) {
            return;
        }

        // Reset the classes, which will be rebuilt below.
        const els = document.getElementsByClassName('current-header');
        for (const el of els) {
            el.classList.remove('current-header');
        }
        for (const toggle of headerToggles) {
            toggle.classList.remove('expanded');
        }

        // Find the last header that is above the threshold.
        let lastHeader = null;
        for (const header of headers) {
            const rect = header.getBoundingClientRect();
            if (rect.top <= threshold) {
                lastHeader = header;
            } else {
                break;
            }
        }
        if (lastHeader === null) {
            lastHeader = headers[0];
            const rect = lastHeader.getBoundingClientRect();
            const windowHeight = window.innerHeight;
            if (rect.top >= windowHeight) {
                return;
            }
        }

        // Get the anchor in the summary.
        const href = '#' + lastHeader.id;
        const a = [...document.querySelectorAll('.header-in-summary')]
            .find(element => element.getAttribute('href') === href);
        if (!a) {
            return;
        }

        a.classList.add('current-header');

        updateHeaderExpanded(a);
    }

    // Updates which header is "current" based on the threshold line.
    function reloadCurrentHeader() {
        if (disableScroll) {
            return;
        }
        updateThreshold();
        updateCurrentHeader();
    }


    // When clicking on a header in the sidebar, this adjusts the threshold so
    // that it is located next to the header. This is so that header becomes
    // "current".
    function headerThresholdClick(event) {
        // See disableScroll description why this is done.
        disableScroll = true;
        setTimeout(() => {
            disableScroll = false;
        }, 100);
        // requestAnimationFrame is used to delay the update of the "current"
        // header until after the scroll is done, and the header is in the new
        // position.
        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                // Closest is needed because if it has child elements like <code>.
                const a = event.target.closest('a');
                const href = a.getAttribute('href');
                const targetId = href.substring(1);
                const targetElement = document.getElementById(targetId);
                if (targetElement) {
                    threshold = targetElement.getBoundingClientRect().bottom;
                    updateCurrentHeader();
                }
            });
        });
    }

    // Takes the nodes from the given head and copies them over to the
    // destination, along with some filtering.
    function filterHeader(source, dest) {
        const clone = source.cloneNode(true);
        clone.querySelectorAll('mark').forEach(mark => {
            mark.replaceWith(...mark.childNodes);
        });
        dest.append(...clone.childNodes);
    }

    // Scans page for headers and adds them to the sidebar.
    document.addEventListener('DOMContentLoaded', function() {
        const activeSection = document.querySelector('#mdbook-sidebar .active');
        if (activeSection === null) {
            return;
        }

        const main = document.getElementsByTagName('main')[0];
        headers = Array.from(main.querySelectorAll('h2, h3, h4, h5, h6'))
            .filter(h => h.id !== '' && h.children.length && h.children[0].tagName === 'A');

        if (headers.length === 0) {
            return;
        }

        // Build a tree of headers in the sidebar.

        const stack = [];

        const firstLevel = parseInt(headers[0].tagName.charAt(1));
        for (let i = 1; i < firstLevel; i++) {
            const ol = document.createElement('ol');
            ol.classList.add('section');
            if (stack.length > 0) {
                stack[stack.length - 1].ol.appendChild(ol);
            }
            stack.push({level: i + 1, ol: ol});
        }

        // The level where it will start folding deeply nested headers.
        const foldLevel = 3;

        for (let i = 0; i < headers.length; i++) {
            const header = headers[i];
            const level = parseInt(header.tagName.charAt(1));

            const currentLevel = stack[stack.length - 1].level;
            if (level > currentLevel) {
                // Begin nesting to this level.
                for (let nextLevel = currentLevel + 1; nextLevel <= level; nextLevel++) {
                    const ol = document.createElement('ol');
                    ol.classList.add('section');
                    const last = stack[stack.length - 1];
                    const lastChild = last.ol.lastChild;
                    // Handle the case where jumping more than one nesting
                    // level, which doesn't have a list item to place this new
                    // list inside of.
                    if (lastChild) {
                        lastChild.appendChild(ol);
                    } else {
                        last.ol.appendChild(ol);
                    }
                    stack.push({level: nextLevel, ol: ol});
                }
            } else if (level < currentLevel) {
                while (stack.length > 1 && stack[stack.length - 1].level > level) {
                    stack.pop();
                }
            }

            const li = document.createElement('li');
            li.classList.add('header-item');
            li.classList.add('expanded');
            if (level < foldLevel) {
                li.classList.add('expanded');
            }
            const span = document.createElement('span');
            span.classList.add('chapter-link-wrapper');
            const a = document.createElement('a');
            span.appendChild(a);
            a.href = '#' + header.id;
            a.classList.add('header-in-summary');
            filterHeader(header.children[0], a);
            a.addEventListener('click', headerThresholdClick);
            const nextHeader = headers[i + 1];
            if (nextHeader !== undefined) {
                const nextLevel = parseInt(nextHeader.tagName.charAt(1));
                if (nextLevel > level && level >= foldLevel) {
                    const toggle = document.createElement('a');
                    toggle.classList.add('chapter-fold-toggle');
                    toggle.classList.add('header-toggle');
                    toggle.addEventListener('click', () => {
                        li.classList.toggle('expanded');
                    });
                    const toggleDiv = document.createElement('div');
                    toggleDiv.textContent = '❱';
                    toggle.appendChild(toggleDiv);
                    span.appendChild(toggle);
                    headerToggles.push(li);
                }
            }
            li.appendChild(span);

            const currentParent = stack[stack.length - 1];
            currentParent.ol.appendChild(li);
        }

        const onThisPage = document.createElement('div');
        onThisPage.classList.add('on-this-page');
        onThisPage.append(stack[0].ol);
        const activeItemSpan = activeSection.parentElement;
        activeItemSpan.after(onThisPage);
    });

    document.addEventListener('DOMContentLoaded', reloadCurrentHeader);
    document.addEventListener('scroll', reloadCurrentHeader, { passive: true });
})();


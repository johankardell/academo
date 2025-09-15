# GitHub Copilot & Coding Agent Custom Instructions

## General
- These instructions are automatically applied to all code suggestions and actions by GitHub Copilot and GitHub Coding Agent in this repository.

## Backend Code
- All backend code **must** be written in **C#**.
- Do not suggest or generate backend code in any other language.

## Infrastructure
- All infrastructure as code (IaC) **must** be declared using **Bicep**.
- Do not use ARM templates, Terraform, or other IaC tools for infrastructure definitions.
- Ensure that all Bicep files are well-documented and follow best practices for readability and maintainability.
- Use Bicep modules to promote reusability and modularity in infrastructure definitions.
- Ensure that all Bicep files are version-controlled and stored in the appropriate directory structure.
- Use descriptive names for Bicep files and modules to clearly indicate their purpose and functionality.
- All infrastructure must be placed in the 'swedencentral' Azure region. Do not use Global or any other region.

## Additional Notes
- Adhere to these requirements for all new features, bug fixes, and refactoring.
- If a request cannot be fulfilled within these constraints, clearly state the limitation.

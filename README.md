# LUX HPC EDU — HPC Educational Simulator

**A browser-based practical learning environment for High-Performance Computing (HPC) and Artificial Intelligence (AI) workflows.**

**[Launch HPC Simulator in GitHub Codespaces](https://codespaces.new/AleksandraRancic1/lux-hpc-edu-mooc?ref=main)**


## Contents

- [About the simulator](#about-the-simulator)
- [Learning objectives](#learning-objectives)
- [Architecture and resources](#architecture-and-resources)
- [Getting started](#getting-started)
- [Understanding the execution environments](#understanding-the-execution-environments)
- [Learning materials and assessment](#learning-materials-and-assessment)
- [Saving work, stopping and resuming](#saving-work-stopping-and-resuming)
- [Troubleshooting](#troubleshooting)
- [Local execution](#local-execution)
- [Limitations, security and responsible use](#limitations-security-and-responsible-use)
- [Release information and support](#release-information-and-support)
- [Authorship and licensing](#authorship-and-licensing)

## About the simulator

LUX HPC EDU is an educational environment designed to help learners acquire the practical competencies required to use high-performance computing systems for scientific computing and artificial intelligence. It reproduces selected user-facing characteristics of a managed HPC cluster using Linux containers, a simulated Slurm-style job management system, shared storage and structured practical activities.

The simulator addresses the operational competency gap between conventional AI education and HPC practice. Knowledge of AI algorithms, Python and machine learning frameworks does not necessarily prepare learners to execute and manage workloads on remote, resource-managed computing systems. HPC users must also understand remote access, Linux environments, shared filesystems, software dependencies, resource allocation, job scheduling, monitoring and troubleshooting.

LUX HPC EDU provides a controlled environment in which learners can develop these competencies before transitioning to production HPC infrastructure. Its educational methodology combines progressive practical learning, selective infrastructure simulation, contextualized AI workflows and automated formative feedback. The aim is to reduce unnecessary infrastructure setup complexity while preserving the essential operational concepts of HPC.

The simulator is intended for students, researchers, AI practitioners and other learners with little or no previous HPC experience. It is designed for independent, self-paced learning and integration into a Massive Open Online Course (MOOC). The recommended access method is GitHub Codespaces, which runs in a web browser without requiring local Docker installation, a physical GPU or an institutional HPC account.

**This is not a production supercomputer.** Linux commands and lightweight programs execute inside real containers, but the advertised HPC resources, GPU information and selected scheduler behaviours are simulated. The environment prioritizes functional and pedagogical fidelity over physical hardware fidelity and is not intended for production AI training or HPC performance benchmarking.

## Learning objectives

By completing the curriculum, learners should be able to:

- Connect to remote HPC environments using SSH and navigate the Linux command line.
- Organize, manage and transfer files between a workstation and an HPC environment.
- Understand HPC architecture, login and compute nodes, shared storage and computational resources.
- Manage software modules, Python virtual environments, Conda environments and application dependencies.
- Request CPU, GPU, memory and wall-time resources according to workload requirements.
- Submit, monitor and manage interactive and batch jobs using Slurm-style commands.
- Interpret job states, accounting information, output logs and error messages.
- Diagnose and resolve common HPC workflow and application errors.
- Understand and use containerized applications with Apptainer.
- Adapt conventional AI workflows for execution in scheduled HPC environments.
- Understand and configure serial, single-node parallel and distributed AI workloads.
- Understand computational scalability, communication overhead and resource utilization.
- Apply principles of computational efficiency, reproducibility and sustainable resource management.
- Independently develop and execute an end-to-end AI–HPC workflow.
- Use automated exercise checkers for formative feedback and independent competency development.
- Distinguish simulated resources and behaviour from actual production HPC performance.

The overarching objective is to prepare learners to transition from conventional AI development environments to the practical use of HPC infrastructure.

## Architecture and resources

Each learner creates an individual Codespace containing a Docker engine and five HPC node containers. Docker Compose manages the containers and their internal network. A startup script initializes the shared storage, starts the login and compute nodes, prepares the learner-facing materials and configures the SSH connection.

```text
Learner's browser
        |
        v
GitHub Codespaces (VS Code web interface)
        |
        | ssh lux-ai-hpc
        v
     login01
        |
        | Slurm-style resource requests and job execution
        |
        +-----------+-----------+-----------+
        v           v           v           v
   compute001  compute002  compute003  compute004

         Shared home, scratch and log storage
```

### Cluster configuration

| Component | Description |
| --- | --- |
| Cluster identifier | `UNI-LUX-EDU` |
| Login node | `login01` |
| Compute nodes | `compute001`–`compute004` |
| Operating system | Ubuntu 24.04 LTS container environments |
| Scheduler interface | Custom educational Slurm-style commands |
| Remote access | SSH from the Codespace workstation |
| Shared storage | Docker named volumes mounted at `/home`, `/scratch` and `/logs` |
| Job history | Simulator-local accounting database |
| Software environment | Simulated modules; real Python, venv and Conda facilities on compute nodes |

### Simulated compute resources

| Resource | Per compute node | Four-node total |
| --- | ---: | ---: |
| CPU cores | 64 | 256 |
| RAM | 256 GB | 1,024 GB |
| NVIDIA A100-SXM4-80GB GPUs | 4 | 16 |

These specifications represent the educational resource model, not the actual physical resources available to learners. The actual CPU, memory and storage capacity depends on the selected Codespaces machine. Simulated resource allocation and GPU visibility do not imply equivalent hardware-level resource enforcement or CUDA acceleration.

### Login and compute nodes

The login node is the entry point for accessing the cluster, managing files, preparing scripts, submitting jobs and monitoring execution. Compute nodes are intended for executing computational workloads through the simulated scheduler.

The nodes share learner storage. Files placed in the learner's HPC home directory are accessible from compute nodes. This storage is separate from the outer Codespace workspace.

## Getting started

### 1. Requirements

You need:

- A GitHub account.
- Access to GitHub Codespaces with sufficient compute and storage quota.
- A stable internet connection and a web browser.

You do not need to clone the repository, install Docker or Linux locally, create a personal access token, install an SSH client on your computer or obtain access to the private development repository.

### 2. Create your Codespace

1. Open the simulator link provided in Moodle or use the following link:

   **[Launch LUX HPC EDU](https://codespaces.new/AleksandraRancic1/lux-hpc-edu-mooc?ref=main)**

2. Sign in to your GitHub account if prompted.
3. Select the `main` branch if required.
4. Choose a 2-core Codespaces machine if available. Review any usage and billing information displayed by GitHub.
5. Select **Create codespace**.

GitHub opens a browser-based Visual Studio Code workspace. The initial setup automatically installs the required container tools, downloads the runtime images, starts the HPC containers and configures the environment.

The first launch may take several minutes. Allow initialization to finish. You do not need to build the images or start the cluster manually.

### 3. Open the terminal and verify that the simulator is running

In the Codespaces web interface, select **Terminal → New Terminal**.

The terminal prompt will resemble:

```text
<github-username> ➜ /workspaces/lux-hpc-edu-mooc (main) $
```

This is your Codespace workstation. You are not yet connected to the HPC login node.

Before connecting, run:

```bash
docker compose ps
```

Confirm that all five services are running:

- `login01`
- `compute001`
- `compute002`
- `compute003`
- `compute004`

Their status should indicate that they are running (for example, `Up`). If any node is missing or stopped, see [Troubleshooting](#troubleshooting) before proceeding.

This is a startup verification step. Learners are not expected to administer Docker.

### 4. Connect to the HPC login node

In the **same Codespace terminal**, enter:

```bash
ssh lux-ai-hpc
```

The alias `lux-ai-hpc` is automatically configured to connect to the learner account on the login container through the local address `127.0.0.1`, port `2222`. Run this command inside your Codespace, not in the terminal of your personal computer.

#### First connection: SSH host verification

On your first connection, SSH may display a message similar to:

```text
The authenticity of host '[127.0.0.1]:2222' can't be established.
ED25519 key fingerprint is SHA256:...
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

This is normal when connecting to a new SSH server. To confirm that you are connecting to your own simulator:

1. Leave the SSH prompt open.
2. Open another terminal using **Terminal → New Terminal**. This second terminal is still in the Codespace workstation.
3. Run the following command to display the login container's ED25519 host-key fingerprint:

   ```bash
   docker exec login01 ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
   ```

4. Compare the `SHA256:...` fingerprint displayed by this command with the fingerprint in the original SSH prompt.
5. If they match, return to the original terminal, type `yes` and press Enter. If they do not match, do not continue; contact the course support team.

SSH saves the verified host key, so you should not normally have to repeat this step when reconnecting to the same container.

#### Training account credentials

When prompted for the password, enter:

| Credential | Value |
| --- | --- |
| Username | `learner` (already set by the SSH alias) |
| Password | `learner` |

The password is not displayed while typing, not even as asterisks. This is normal. Type the password and press Enter.

A successful connection displays the **HPC Educational Simulator** welcome banner and the following prompt:

```text
learner@login01:~$
```

### 5. Verify your HPC connection

From the HPC login node, run:

```bash
hostname
whoami
pwd
```

Expected output:

```text
login01
learner
/home/learner
```

You are now connected to the simulated HPC environment. Open the learning materials in the Codespace file explorer and begin with Exercise 00.

## Understanding the execution environments

The distinction between a workstation, an HPC login node and a compute node is a fundamental learning objective.

| Environment | Typical terminal prompt | Purpose |
| --- | --- | --- |
| Codespace workstation | `<username> ➜ /workspaces/lux-hpc-edu-mooc (main) $` | Read learning materials, prepare local files, initiate SSH and file transfers |
| HPC login node | `learner@login01:~$` | Manage HPC files, prepare and submit jobs, monitor execution |
| HPC compute node | `learner@compute001:~$` or similar | Execute workloads and configure compute-side software environments |

Keep two terminal tabs open when necessary: one for the Codespace workstation and another connected to the HPC login node.

When exercise instructions refer to the local machine or workstation, they mean the outer Codespace terminal unless stated otherwise. Always check your terminal prompt before executing a command.

To disconnect from the HPC login node, run:

```bash
exit
```

This returns you to the Codespace workstation. It does not stop the Codespace. If you are in an interactive compute session, `exit` may first return you to the login node; check the prompt.

## Learning materials and assessment

The learner-facing workspace is designed to contain the following structure after initialization:

```text
lux-hpc-edu-mooc/
├── README.md
├── docker-compose.yml
├── .devcontainer/
├── exercises/
└── exercise-files/
```

- `exercises/` contains the complete practical instructions in Markdown format.
- `exercise-files/` contains supporting scripts, datasets and configuration files.
- Exercise checkers are provided inside the simulated HPC environment.

Open the Markdown instructions directly in the VS Code file explorer. To view formatted instructions beside the terminal, right-click a Markdown file and select **Open Preview** or **Open Preview to the Side**.

Begin with Exercise 00 and follow the numerical sequence and the Moodle course instructions. All exercise-specific procedures, commands, expected results and assessment requirements are provided in the individual exercise files rather than duplicated in this README.

Where provided, run the exercise-specific `check-exercise` command in the HPC environment, using the number and execution context specified in the exercise instructions. The checkers provide immediate formative feedback and support repeated practice and independent problem-solving. They are not a secure examination mechanism, do not establish mastery by themselves and do not automatically report results to Moodle.

The learning materials are generated in the Codespace workspace from the runtime image. Existing copies may be retained to preserve learner edits. Follow course guidance before updating or replacing them.

If learning materials are missing, see [Troubleshooting](#troubleshooting).

## Saving work, stopping and resuming

### Save and back up your work

Files in the outer Codespace workspace and files in your HPC home directory are stored separately. Docker named volumes are intended to preserve simulator state across ordinary container restarts, but they are not a backup.

Before rebuilding, resetting or deleting a Codespace, copy important files from the HPC environment into the outer workspace and download them to your computer using the VS Code file explorer.

For example, if your HPC project directory is `~/project`, run the following from the **Codespace workstation**:

```bash
mkdir -p hpc-backup
scp -r lux-ai-hpc:~/project ./hpc-backup/
```

Adapt the path to your actual files. Verify the backup, including any other scripts, logs or outputs you need, before deleting anything. Do not commit personal or sensitive information to a public repository.

### Stop your Codespace

When you finish a learning session:

1. Save your files and disconnect from the HPC environment using `exit`.
2. Open the VS Code Command Palette (`Ctrl+Shift+P` on Windows/Linux or `Cmd+Shift+P` on macOS).
3. Select **Codespaces: Stop Codespace**.

Alternatively, open [github.com/codespaces](https://github.com/codespaces) and stop your Codespace from its menu.

**Closing the browser tab does not necessarily stop the Codespace.** A running Codespace may continue to consume compute quota, while a stopped Codespace may still consume storage quota.

### Resume your existing Codespace

1. Open [github.com/codespaces](https://github.com/codespaces).
2. Locate and reopen your existing `lux-hpc-edu-mooc` Codespace.
3. Allow the simulator startup script to complete.
4. Open the terminal and reconnect:

   ```bash
   ssh lux-ai-hpc
   ```

Do not create a new Codespace for each exercise. Reusing the same environment is intended to preserve your progress. Keep independent backups of important files, particularly before rebuilding or deleting a Codespace.

### Quotas and costs

GitHub Codespaces is subject to account eligibility, compute and storage quotas, usage policies and billing settings. Check your account's available quota and follow the course instructions before enabling paid usage. Free or unlimited access is not guaranteed.

See [GitHub Codespaces included usage guidance](https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-included-usage) and [stopping and starting a Codespace](https://docs.github.com/en/codespaces/developing-in-a-codespace/stopping-and-starting-a-codespace).

## Troubleshooting

Run Docker and SSH diagnostic commands from the **outer Codespace workstation**, not from the HPC login or compute node.

| Problem | Recommended action |
| --- | --- |
| Unable to create a Codespace | Check your GitHub account, available quota, billing settings and organization restrictions. |
| `Could not resolve hostname lux-ai-hpc` | Confirm that you are in the outer Codespace terminal and that initialization has completed. |
| `Connection refused` | Run `docker compose ps` and confirm that the login container is running. Follow startup recovery below if necessary. |
| SSH first-connection prompt | Follow the host fingerprint verification instructions in Getting started. |
| Password characters are not displayed | This is normal. Enter `learner` and press Enter. |
| SSH host key has changed | Do not bypass the warning. Follow the host-key change guidance below. |
| Missing exercise files | Check whether you are in the outer workspace or the HPC environment. Follow the missing-materials guidance below. |
| `docker: command not found` or recovery mode | Open the Codespaces creation log and report the error to the course support team. |
| Exercise checker reports failure | Review the exercise instructions and checker feedback, correct the problem and retry. |

### Startup recovery

If Docker is available but the simulator has not started, open a Codespace terminal in the launcher repository and run:

```bash
bash .devcontainer/start-simulator.sh
```

After successful startup, verify the containers and reconnect:

```bash
docker compose ps
ssh lux-ai-hpc
```

If Codespaces opens in recovery mode, use the Command Palette and select **Codespaces: View Creation Log**. Report the relevant error messages to the course support team rather than installing Docker manually.

Do not use `docker compose down -v`. This can delete shared storage, job history and learner progress. Rebuilding is a recovery action, not a routine startup step.

### Missing learning materials

If the `exercises/` or `exercise-files/` directory is missing, first run the startup script as described above. If it remains missing, contact the course support team.

The original materials are packaged inside the running login container at:

```text
/opt/lux-hpc-edu/exercises/
/opt/lux-hpc-edu/exercise-files/
```

Do not delete or overwrite existing learner materials to recover missing files without first backing up your work.

### SSH host-key change

An SSH host-key change can occur when the login container is recreated. Do not ignore the warning. Confirm that the container was intentionally recreated and verify the new fingerprint using the command in the first-connection instructions.

Only after confirming the recreation and verifying the new key, remove the stale entry from the Codespace workstation:

```bash
ssh-keygen -R '[127.0.0.1]:2222'
ssh lux-ai-hpc
```

Compare the new prompt with the verified fingerprint before accepting it. Never disable host-key verification globally. If the change is unexpected, contact course support.

## Local execution

The launcher repository and runtime images are publicly accessible. It is therefore technically possible to clone the launcher and run the simulator outside GitHub Codespaces without access to the private development repository.

**GitHub Codespaces is the officially supported access method for the MOOC.** Local installation is not required, and local execution across different operating systems and hardware architectures has not been fully validated.

The published images target `linux/amd64`. Other architectures, including ARM64, may require emulation or additional configuration.

The simulator currently mounts the Docker socket inside the login container, providing extensive access to the Docker daemon. For security reasons, local testing should only be performed by experienced users in a dedicated, disposable Linux virtual machine with a separate Docker daemon, no sensitive data and no public SSH port exposure.

For advanced testing within such an isolated VM, the prerequisites are Git, Bash, Docker Engine, Docker Compose v2 and OpenSSH. The following commands may be used to attempt initialization:

```bash
git clone https://github.com/AleksandraRancic1/lux-hpc-edu-mooc.git
cd lux-hpc-edu-mooc
bash .devcontainer/start-simulator.sh
```

After verifying that the five containers are running, connect using `ssh lux-ai-hpc` and the training credentials described above. If local setup fails, use the supported Codespaces method.

## Limitations, security and responsible use

- LUX HPC EDU is an educational simulation, not a complete production Slurm installation or a physical multi-node cluster.
- Virtual resource specifications and GPU information do not indicate access to physical A100 GPUs, production GPU acceleration or equivalent hardware-level resource enforcement.
- Execution time, scaling, resource utilization and sustainability examples must not be interpreted as measurements of production HPC hardware.
- The environment is designed for individual learners, not shared multi-user production hosting.
- Use the designated training credentials only within your own simulator. Do not reuse the training password for personal or institutional accounts.
- Keep the SSH endpoint private. Do not publicly forward or expose port `2222`.
- Do not upload sensitive, confidential, personal or regulated datasets or execute unrelated resource-intensive workloads.
- The launcher and runtime images are public; Moodle enrollment does not restrict access to these public resources. Packaged scripts and checkers are inspectable, while the private development repository is not distributed.
- Availability depends on GitHub Codespaces service availability, account eligibility and usage limits.

## Release information and support

The simulator uses separate, versioned login and compute runtime images hosted in GitHub Container Registry (GHCR). The exact image tags used by the launcher are specified in `docker-compose.yml`.

The public launcher is maintained separately from the private development source. Participants do not require private repository access. Follow the course instructions when updating to a new runtime version or replacing generated learning materials.

For questions or technical problems, use the support channel designated in Moodle. Include the exercise number where relevant, the command you entered, the environment in which it was executed (workstation, login or compute node), and the relevant error message. Never include passwords, access tokens or sensitive files.

### Useful links

- [Launch the simulator](https://codespaces.new/AleksandraRancic1/lux-hpc-edu-mooc)
- [Public launcher repository](https://github.com/AleksandraRancic1/lux-hpc-edu-mooc)
- [Manage your Codespaces](https://github.com/codespaces)

## Authorship, copyright and intellectual property

**Original author and developer:** Aleksandra Rancic

**Institution and intellectual property owner:** University of Luxembourg

Copyright © 2026 University of Luxembourg. All rights reserved.

LUX HPC EDU is an educational software platform developed at the University of Luxembourg.

Public availability of the simulator does not constitute an open-source licence or a transfer of intellectual property rights.

Unauthorised modification, reproduction, redistribution, commercial exploitation, removal of authorship attribution or misrepresentation of authorship is prohibited, except where permitted by applicable law or expressly authorised by the rights holder.

Third-party software components remain subject to their respective licences.

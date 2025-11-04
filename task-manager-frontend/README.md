# Task Manager Frontend

A modern Next.js web application for task management with TypeScript and Tailwind CSS.

## Features

- ⚡ Next.js 16 with App Router
- 🔷 TypeScript for type safety
- 🎨 Tailwind CSS for styling
- 📱 Responsive design
- 🔄 Real-time task management
- 🌐 RESTful API integration

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (version 18 or higher)
- npm, yarn, pnpm, or bun

### Installation

1. Navigate to the frontend directory:
   ```bash
   cd task-manager-frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Ensure the backend API is running (see root README.md)

### Running the Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Project Structure

```
src/
├── app/
│   ├── layout.tsx       # Root layout
│   ├── page.tsx         # Home page
│   └── globals.css      # Global styles
├── components/
│   ├── AddTaskForm.tsx  # Form to add tasks
│   ├── EditTaskForm.tsx # Form to edit tasks
│   └── TaskList.tsx     # Task list display
├── services/
│   └── api.ts           # API service functions
└── types/
    └── task.ts          # TypeScript type definitions
```

## Technologies Used

- **Next.js 16**: React framework with App Router
- **React 19**: UI library
- **TypeScript**: Type-safe JavaScript
- **Tailwind CSS**: Utility-first CSS framework
- **ESLint**: Code linting

## API Integration

The frontend communicates with the TaskManagerAPI backend through the `api.ts` service file. The API base URL is configured in the service file.

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint

## Building for Production

```bash
npm run build
npm run start
```

## Deployment

### Vercel (Recommended)

1. Push your code to GitHub
2. Connect your repository to [Vercel](https://vercel.com)
3. Deploy automatically

### Manual Deployment

```bash
npm run build
npm run start
```

## Environment Variables

Create a `.env.local` file for environment-specific configurations:

```env
NEXT_PUBLIC_API_URL=http://localhost:5000
```

## Contributing

1. Follow TypeScript and React best practices
2. Use Tailwind CSS for styling
3. Test API integration thoroughly
4. Ensure responsive design

## Troubleshooting

- **Build issues**: Clear `.next` folder and reinstall dependencies
- **API connection issues**: Verify backend is running and CORS is configured
- **Styling issues**: Check Tailwind CSS configuration
